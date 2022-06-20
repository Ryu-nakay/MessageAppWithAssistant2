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

    var userData = UserData()

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
                    tempDelegate!.chatTableView.reloadData()
                }
            })
            .store(in: &self.cancellables)
    }

    func tryToGetChatData(roomId: String, start: Int, count: Int) {
        self.chat.tryToGetChatData(roomId: roomId, start: start, count: count)
    }

    func tryToGetUserNamePublisher(userId: String) -> AnyPublisher<UserInfo, Error> {
        return self.userData.tryToGetUserPublisher(userId: userId)
    }
}
