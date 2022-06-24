//
//  WebSocketConnecter.swift
//  MessageAppWithAssistant
//
//  Created by 中山龍 on 2022/06/24.
//

import Foundation


var webSocketConnecter = WebSocketConnecter()

struct WebSocketConnecter {
    let webSocketTask = URLSession(configuration: .default).webSocketTask(with: URL(string: "wss://cu4v0xfnsb.execute-api.us-west-1.amazonaws.com/production")!)

    func connect() {
        webSocketTask.resume()

        guard let myUserId = UserDefaults.standard.string(forKey: "userId") else {
            return
        }
        var bodyContent: [String: Any] = ["action":"userassociation", "userId":myUserId]

        var bodyString: String = ""

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: bodyContent, options: [])
            let jsonStr = String(bytes: jsonData, encoding: .utf8)!
            bodyString = jsonStr

            let sendContent = URLSessionWebSocketTask.Message.string(bodyString)
            webSocketTask.send(sendContent) { error in
                if let error = error {
                    print(error)  // some error handling
                } else {
                    print("my infomation was sent!")
                }
            }
        } catch let error {
            print(error)
        }
    }
}
