//
//  MessageSender.swift
//  MessageAppWithAssistant
//
//  Created by 中山龍 on 2022/06/24.
//

import Foundation

struct MessageSender {
    func send(roomId: String,contents: String) {
        guard let myUserId = UserDefaults.standard.string(forKey: "userId") else {
            return
        }
        var bodyContent: [String: Any] = [
            "action":"sendmessage",
            "roomId": roomId,
            "userId": myUserId,
            "contentsType":"message",
            "contents":contents
        ]

        var bodyString: String = ""

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: bodyContent, options: [])
            let jsonStr = String(bytes: jsonData, encoding: .utf8)!
            bodyString = jsonStr

            let sendContent = URLSessionWebSocketTask.Message.string(bodyString)
            webSocketConnecter.webSocketTask.send(sendContent) { error in
                if let error = error {
                    print(error)  // some error handling
                } else {
                    print("my message was sent!")
                }
            }
        } catch let error {
            print(error)
        }
    }
}
