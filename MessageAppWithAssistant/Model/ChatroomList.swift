//
//  ChatroomList.swift
//  MessageAppWithAssistant
//
//  Created by 中山龍 on 2022/06/13.
//

import Foundation
import Combine

class ChatroomList {

    @Published var isLoading = false

    @Published var roomlist = [RoomItem]()

    private var cancellables = Set<AnyCancellable>()
}

extension ChatroomList {
    func tryToGetChatroomList() {
        // APIへのURL
        let url = "https://hbh6aoer97.execute-api.us-west-1.amazonaws.com/test/getrooms"

        self.isLoading = true


        tryToGetRoomlistPublisher()
            .sink(receiveValue: { result in
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.roomlist = result
                    print("\(self.roomlist.count)")
                }
            })
            .store(in: &self.cancellables)

        func tryToGetRoomlistPublisher() -> AnyPublisher<[RoomItem], Never> {

            var request = URLRequest(url: URL(string: url)!)
            // HTTPメソッド
            request.httpMethod="POST"

            let bodyContent: [String: Any] = ["userId": UserDefaults.standard.string(forKey: "userId")!]

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: bodyContent, options: [])
                let jsonStr = String(bytes: jsonData, encoding: .utf8)!
                let bodyString = jsonStr
                // HTTPのbodyにメッセージを付与
                request.httpBody="\(bodyString)".data(using: .utf8)
            } catch let error {
                print(error)
            }

            return Future<[RoomItem], Never> { promise in
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
                                print("result: \(result.body.roomList.count)")
                                promise(.success(result.body.roomList))
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
                    let body: ResponseRoomList
                    struct ResponseRoomList: Codable{
                        let roomList: [RoomItem]
                    }
                }
            }.eraseToAnyPublisher()
        }
    }
}


struct RoomItem: Codable{
    let roomId: String
    let roomName: String
    let lastUpdate: Double
    let roomType: String

}
