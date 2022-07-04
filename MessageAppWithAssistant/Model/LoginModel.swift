//
//  LoginModel.swift
//  MessageAppWithAssistant
//
//  Created by 中山龍 on 2022/06/04.
//

import Foundation
import Combine

class LoginModel {
    // ログイン済みかどうかを判定するフラグ
    @Published var isLogin: Bool = false
    // API通信中かどうか
    @Published var isLoading = false
    // 初期設定が済んでいるか
    @Published var hasInformation = false

    // LoginAPIへのURL
    let loginUrl = "https://hbh6aoer97.execute-api.us-west-1.amazonaws.com/test/login"

    // cancellablesの生成
    private var cancellables = Set<AnyCancellable>()




}


// ログイン機能のextension
extension LoginModel {
    // ログイン機能
    func tryToLogin(email: String, password: String) {
        self.isLoading = true
        tryToLoginPubliher(email: email, password: password)
            .sink(receiveValue: { result in
                DispatchQueue.main.async {
                    self.isLogin = result
                    print("result is \(result)")
                    self.isLoading = false
                }
            })
            .store(in: &cancellables)
    }

    func tryToLoginPubliher(email: String, password: String) -> AnyPublisher<Bool, Never> {

        var request = URLRequest(url: URL(string: loginUrl)!)
        // HTTPメソッド
        request.httpMethod="POST"

        let bodyContent: [String: Any] = ["email": email, "password": password]

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

                    var result: LoginResult

                    if response.statusCode == 200 {
                        do {
                            result = try JSONDecoder().decode(LoginResult.self, from: data)
                            print("result: \(result.body.responseCode)")
                            if result.body.userName != "null" {
                                self.hasInformation = true
                            }
                            UserDefaults.standard.set(result.body.userId, forKey: "userId")
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


            class LoginResult: Codable {
                let body: AuthenticationResult

                class AuthenticationResult: Codable{
                    let responseCode: Int
                    let userId: String
                    let userName: String
                }
            }
        }.eraseToAnyPublisher()
    }
}



// サインアップ機能のextension
extension LoginModel {
    // Signup機能
    func tryToSignup(email: String, password: String) {
        // SignupAPIへのURL
        let signupUrl = "https://hbh6aoer97.execute-api.us-west-1.amazonaws.com/test/signup"

        self.isLoading = true


        tryToSignupPubliher(email: email, password: password)
            .sink(receiveValue: { result in
                DispatchQueue.main.async {
                    self.isLogin = result
                    print("result is \(result)")
                    self.isLoading = false
                }
            })
            .store(in: &cancellables)

        func tryToSignupPubliher(email: String, password: String) -> AnyPublisher<Bool, Never> {

            var request = URLRequest(url: URL(string: signupUrl)!)
            // HTTPメソッド
            request.httpMethod="POST"

            let bodyContent: [String: Any] = ["email": email, "password": password]

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

                        var result: SignupResult

                        if response.statusCode == 200 {
                            do {
                                result = try JSONDecoder().decode(SignupResult.self, from: data)
                                print("result: \(result.body.responseCode)")
                                if result.body.responseCode == 0 {
                                    UserDefaults.standard.set(result.body.userId, forKey: "userId")
                                }
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


                class SignupResult: Codable {
                    let body: ResponseCode

                    class ResponseCode: Codable{
                        let responseCode: Int
                        let userId: String
                    }
                }
            }.eraseToAnyPublisher()
        }
    }
}
