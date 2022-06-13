//
//  SettingModel.swift
//  MessageAppWithAssistant
//
//  Created by 中山龍 on 2022/06/07.
//

import Foundation
import Combine

class SettingModel {
    @Published var isLoading = false
    @Published var hasInformation = false

    // cancellablesの生成
    private var cancellables = Set<AnyCancellable>()
}

// 初期設定機能のextension
extension SettingModel {
    // 初期設定機能
    func tryToInitialSetting(userName: String,searchId: String) {
        // InitialSettingAPIへのURL
        let url = "https://hbh6aoer97.execute-api.us-west-1.amazonaws.com/test/initialsetting"

        self.isLoading = true


        tryToInitialSettingPublisher(userName: userName, searchId: searchId)
            .sink(receiveValue: { result in
                DispatchQueue.main.async {
                    self.hasInformation = result
                    print("result is \(result)")
                    self.isLoading = false
                }
            })
            .store(in: &cancellables)

        func tryToInitialSettingPublisher(userName: String, searchId: String) -> AnyPublisher<Bool, Never> {

            var request = URLRequest(url: URL(string: url)!)
            // HTTPメソッド
            request.httpMethod="POST"

            let bodyContent: [String: Any] = ["userId": UserDefaults.standard.string(forKey: "userId")!, "searchId": searchId, "userName": userName]

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: bodyContent, options: [])
                let jsonStr = String(bytes: jsonData, encoding: .utf8)!
                let bodyString = jsonStr
                // HTTPのbodyにメッセージを付与
                request.httpBody="\(bodyString)".data(using: .utf8)
            } catch let error {
                print(error)
            }

            return Future<Bool, Never> { promise in
                // POSTを行う
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if error == nil, let data = data, let response = response as? HTTPURLResponse {
                        // HTTPヘッダの取得
                        print("Content-Type: \(response.allHeaderFields["Content-Type"] ?? "")")
                        // HTTPステータスコード
                        print("statusCode: \(response.statusCode)")
                        print(String(data: data, encoding: .utf8) ?? "")

                        var result: InitialSettingResult

                        if response.statusCode == 200 {
                            do {
                                result = try JSONDecoder().decode(InitialSettingResult.self, from: data)
                                print("result: \(result.body.responseCode)")
                                promise(.success(result.body.responseCode == 0 ? true : false))
                            } catch let error {
                                print(error) // エラー
                                promise(.success(false))
                            }
                        } else {
                            promise(.success(false))
                        }
                    }
                }.resume()


                class InitialSettingResult: Codable {
                    let body: AuthenticationResult

                    class AuthenticationResult: Codable{
                        let responseCode: Int
                    }
                }
            }.eraseToAnyPublisher()
        }
    }
}
