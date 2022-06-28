//
//  MessageGetter.swift
//  MessageAppWithAssistant
//
//  Created by 中山龍 on 2022/06/24.
//

import Foundation
import Combine

class MessageListener {

    var listenResultPublisher: PassthroughSubject<ReceiveMessage, Never> = .init()

    var cancellables = Set<AnyCancellable>()

    func listenningMessage() {
        webSocketConnecter.webSocketTask.receive { [weak self] result in
            switch result {
                case .success(let message):
                    switch message {
                        case .string(let text):
                            print("Received! text: \(text)")
                            print(type(of: text.data(using: .utf8)))


                        guard let receiveMessage = try? JSONSerialization.jsonObject(with: text.data(using: .utf8)!, options: []) as? [String: Any] else {
                            fatalError("Failed to decode from JSON.")
                        }

                        let resultResponse = ReceiveMessage(
                            roomId: receiveMessage["roomId"] as! String,
                            chatId: receiveMessage["chatId"] as! String,
                            sendUserId: receiveMessage["sendUserId"] as! String,
                            contentsType: receiveMessage["contentsType"] as! String,
                            contents: receiveMessage["contents"] as! String,
                            sendTime: receiveMessage["sendTime"] as! Double
                        )

                        self!.listenResultPublisher.send(resultResponse)

                        

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

    deinit {
        print("listenningMessage flag 切り替え")
    }
}

struct ReceiveMessage: Codable {
    var roomId: String
    var chatId: String
    var sendUserId: String
    var contentsType: String
    var contents: String
    var sendTime: Double
}
