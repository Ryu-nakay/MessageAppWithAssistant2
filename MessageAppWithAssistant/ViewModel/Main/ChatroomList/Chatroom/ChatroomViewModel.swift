//
//  ChatroomViewModel.swift
//  MessageAppWithAssistant
//
//  Created by 中山龍 on 2022/06/14.
//

import Foundation
import UIKit
import Combine

class ChatroomViewModel: UseActivityIndicator {
    var activityIndicatorView = UIActivityIndicatorView()

    var delegate: UIViewController?

    var chat = Chat()
    var messageSender = MessageSender()
    var userData = UserData()

    weak var view: ChatroomViewController?

    // ローディングフラグ
    @Published var isLoading: Bool = false
    @Published var chatList = [ChatItem]()

    private var cancellables = Set<AnyCancellable>()

    init() {
        self.chat.$isLoading.assign(to: &self.$isLoading)

        self.$isLoading
            .sink( receiveValue: { value in
                    if value == true {
                        // ローディング中ならインジケータ表示
                        self.startLoadingIndicator()
                    } else {
                        // ローディング中でないならインジケーター非表示
                        self.stopLoadingIndicator()
                    }
                }
            )
            .store(in: &cancellables)

        self.chat.$chatList
            .sink(receiveValue: { receiveChat in
                self.chatList = receiveChat
                let tempDelegate = self.delegate as? ChatroomViewController
                if let _ = tempDelegate {
                    DispatchQueue.main.async {
                        tempDelegate!.chatTableView.reloadData()
                        let indexPath = IndexPath(row: self.chat.chatList.count-1, section: 0)
                        tempDelegate?.chatTableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: false)
                    }
                }
            })
            .store(in: &self.cancellables)

        webSocketConnecter.messageListener.listenResultPublisher
            .sink(receiveValue: { receiveMessage in
                print(receiveMessage.contents)
                if receiveMessage.roomId == self.view?.roomInfo?.roomId {
                    print("この部屋のメッセージ")
                    self.chat.chatList.append(ChatItem(
                        chatId: receiveMessage.chatId,
                        sendUserId: receiveMessage.sendUserId,
                        contentsType: receiveMessage.contentsType,
                        contents: receiveMessage.contents,
                        sendTime: receiveMessage.sendTime
                    ))
                } else {
                    print("\(receiveMessage.roomId)")
                    print("\(self.view?.roomInfo?.roomId)")
                    print("違う部屋のメッセージ")
                }
            })
            .store(in: &self.cancellables)

    }

    func onTapSendButton(roomId: String, contents: String) {
        self.messageSender.send(roomId: roomId, contents: contents)
    }

    func tryToGetChatData(roomId: String, start: Int, count: Int) {
        self.chat.tryToGetChatData(roomId: roomId, start: start, count: count)
    }

    func tryToGetUserNamePublisher(userId: String) -> AnyPublisher<UserInfo, Error> {
        return self.userData.tryToGetUserPublisher(userId: userId)
    }
}
