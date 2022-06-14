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

        self.chat.$chatList.assign(to: &self.$chatList)

        self.$chatList
            .sink(receiveValue: { receiveChat in
                receiveChat.map({ chatItem in
                    print(chatItem.contents)
                })
            })
            .store(in: &self.cancellables)
    }

    func tryToGetChatData(roomId: String, start: Int, count: Int) {
        self.chat.tryToGetChatData(roomId: roomId, start: start, count: count)
    }
}
