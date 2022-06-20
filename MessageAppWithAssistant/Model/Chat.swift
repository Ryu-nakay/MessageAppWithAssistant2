//
//  Chat.swift
//  MessageAppWithAssistant
//
//  Created by 中山龍 on 2022/06/14.
//

import Foundation
import Combine

class Chat {

    @Published var isLoading = false

    @Published var chatList = [ChatItem]()

    private var cancellables = Set<AnyCancellable>()
}

extension Chat {
    func tryToGetChatData(roomId: String, start: Int, count: Int) {
        // APIへのURL
        let url = "https://hbh6aoer97.execute-api.us-west-1.amazonaws.com/test/getchats"

        self.isLoading = true


        tryToGetChatDataPublisher(roomId: roomId, start: start, count: count)
            .sink(receiveValue: { result in
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.chatList = result
                    print("\(self.chatList.count)")
                }
            })
            .store(in: &self.cancellables)

        func tryToGetChatDataPublisher(roomId: String, start: Int, count: Int) -> AnyPublisher<[ChatItem], Never> {

            var request = URLRequest(url: URL(string: url)!)
            // HTTPメソッド
            request.httpMethod="POST"
            
            let bodyContent: [String: Any] = ["roomId": roomId ,"startPosition":start ,"acquisitionCount": count]


            do {
                let jsonData = try JSONSerialization.data(withJSONObject: bodyContent, options: [])
                let jsonStr = String(bytes: jsonData, encoding: .utf8)!
                let bodyString = jsonStr
                // HTTPのbodyにメッセージを付与
                request.httpBody="\(bodyString)".data(using: .utf8)
            } catch let error {
                print(error)
            }

            return Future<[ChatItem], Never> { promise in
                // POSTを行う
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if error == nil, let data = data, let response = response as? HTTPURLResponse {
                        // HTTPヘッダの取得
                        print("Content-Type: \(response.allHeaderFields["Content-Type"] ?? "")")
                        // HTTPステータスコード
                        print("statusCode: \(response.statusCode)")
                        print(String(data: data, encoding: .utf8) ?? "")

                        var result: Response

                        if response.statusCode == 200 {
                            do {
                                result = try JSONDecoder().decode(Response.self, from: data)
                                print("result: \(result.body.chatList.count)")
                                // チャットデータのソート
                                result.body.chatList.sort(by: {
                                    $0.sendTime < $1.sendTime
                                })
                                promise(.success(result.body.chatList))
                            } catch let error {
                                print(error) // エラー
                                promise(.success([]))
                            }
                        } else {
                            promise(.success([]))
                        }
                    }
                }.resume()


                struct Response: Codable {
                    var body: ResponseRoomList
                    struct ResponseRoomList: Codable{
                        var chatList: [ChatItem]
                    }
                }
            }.eraseToAnyPublisher()
        }
    }
}


struct ChatItem: Codable{
    let chatId: String
    let sendUserId: String
    let contentsType: String
    let contents: String
    let sendTime: Double
}
