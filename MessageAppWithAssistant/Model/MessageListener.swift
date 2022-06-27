//
//  MessageGetter.swift
//  MessageAppWithAssistant
//
//  Created by 中山龍 on 2022/06/24.
//

import Foundation

class MessageListener {
    var chat: Chat?

    func injectChatModel(chat: Chat) {
        self.chat = chat
        print("MessageListerner: injected chat model")
    }

    func listenningMessage() {
        webSocketConnecter.webSocketTask.receive { [weak self] result in
            print("///////////////////////////\(result)")
            //guard let receiveMessage = try? JSONDecoder().decode(ReceiveMessage.self, from: message) else {
              //  fatalError("Failed to decode from JSON.")
            //}

            switch result {
                case .success(let message):



                    switch message {
                        case .string(let text):
                            print("Received! text: \(text)")
                            print(type(of: text.data(using: .utf8)))


                        guard let receiveMessage = try? JSONSerialization.jsonObject(with: text.data(using: .utf8)!, options: []) as? [String: Any] else {
                            fatalError("Failed to decode from JSON.")
                        }

                        print("receiveMessage Sting Any:\(receiveMessage)")

                        print(receiveMessage["contents"])

                        let resultResponse = ReceiveMessage(
                            roomId: receiveMessage["roomId"] as! String,
                            chatId: receiveMessage["chatId"] as! String,
                            sendUserId: receiveMessage["sendUserId"] as! String,
                            contentsType: receiveMessage["contentsType"] as! String,
                            contents: receiveMessage["contents"] as! String,
                            sendTime: receiveMessage["sendTime"] as! Double
                        )

                        if self?.chat != nil {
                            DispatchQueue.main.async {
                                self?.chat?.chatList.append(ChatItem(
                                        chatId: resultResponse.chatId,
                                        sendUserId: resultResponse.sendUserId,
                                        contentsType: resultResponse.contentsType,
                                        contents: resultResponse.contents,
                                        sendTime: resultResponse.sendTime
                                    )
                                )
                            }


                            print("chatListに要素追加OK")
                        } else {
                            print("chatListに要素追加失敗")
                        }

                        

                        case .data(let data):
                            print("Received! binary: \(data)")
                        @unknown default:
                            fatalError()
                    }

                self!.listenningMessage()  // <- 継続して受信するために再帰的に呼び出す
                    case .failure(let error):
                        print("Failed! error: \(error)")
            }
        }
    }


    private struct ReceiveMessage: Codable {
        var roomId: String
        var chatId: String
        var sendUserId: String
        var contentsType: String
        var contents: String
        var sendTime: Double
    }
}

/*
 {
    \"roomId\": \"room-uuid1\",
    \"chatId\": \"chat-e0e3d242-8fe9-4ded-b061-779a592e8158\",
    \"sendUserId\": \"user-uuid1\",
    \"contentsType\": \"message\",
    \"contents\": \"\\u30e1\\u30c3\\u30bb\\u30fc\\u30b8\\u5165\\u529b\",
    \"sendTime\": 1656050541.310043
 }
 */
