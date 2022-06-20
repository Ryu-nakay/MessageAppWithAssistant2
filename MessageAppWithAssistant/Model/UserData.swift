//
//  UserData.swift
//  MessageAppWithAssistant
//
//  Created by 中山龍 on 2022/06/20.
//

import Foundation
import Combine
import RealmSwift

struct UserData {

    func tryToGetUserPublisher(userId: String) -> AnyPublisher<UserInfo, Error> {
        var request = URLRequest(url: URL(string: "https://hbh6aoer97.execute-api.us-west-1.amazonaws.com/test/getuser")!)
        // HTTPメソッド
        request.httpMethod="POST"

        let bodyContent: [String: Any] = ["userId": userId]


        do {
            let jsonData = try JSONSerialization.data(withJSONObject: bodyContent, options: [])
            let jsonStr = String(bytes: jsonData, encoding: .utf8)!
            let bodyString = jsonStr
            // HTTPのbodyにメッセージを付与
            request.httpBody="\(bodyString)".data(using: .utf8)
        } catch let error {
            print(error)
        }

        return Future<UserInfo, Error> { promise in
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
                            print("result: \(result.body.userName)")

                            let resultUserInfo = UserInfo()

                            resultUserInfo.userId = userId
                            resultUserInfo.userName = result.body.userName
                            resultUserInfo.searchId = result.body.searchId

                            let realm = try! Realm()
                            try! realm.write {
                                print("取り出したよ")
                                let targetUserInfo = realm.objects(UserInfo.self).filter(NSPredicate(format: "userId == %@", resultUserInfo.userId))
                                print("取り出せたよ")
                                if targetUserInfo.count == 0 {
                                    realm.add(resultUserInfo)
                                } else {
                                    targetUserInfo[0].searchId = resultUserInfo.searchId
                                    targetUserInfo[0].userName = resultUserInfo.userName
                                }

                            }
                             
                            promise(.success(resultUserInfo))
                        } catch let error {
                            print(error) // エラー
                            promise(.failure(error))
                        }
                    } else {
                        promise(.failure(error!))
                    }
                }
            }.resume()


            struct Response: Codable {
                var body: ResponseUserInfo
                struct ResponseUserInfo: Codable{
                    var searchId: String
                    var userName: String
                }
            }
        }.eraseToAnyPublisher()
    }
}

class UserInfo: Object {
    @objc dynamic var userId: String = ""
    @objc dynamic var searchId: String = ""
    @objc dynamic var userName: String = ""
}
