//
//  MessageGetter.swift
//  MessageAppWithAssistant
//
//  Created by 中山龍 on 2022/06/24.
//

import Foundation

class MessageListener {
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

                            //guard let receiveMessage = try? JSONDecoder().decode(ReceiveMessage.self, from:  text.data(using: .utf8)!) else {
                              //  fatalError("Failed to decode from JSON.")
                            //}

                            //print(receiveMessage)
                        /*
                            DispatchQueue.main.async {
                                self!.contentLabel.text! =  self!.contentLabel.text!+"\n \(text)"
                            }
                         */
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
        var sendTime: String
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
