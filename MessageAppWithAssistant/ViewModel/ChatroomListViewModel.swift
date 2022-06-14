//
//  ChatroomListViewModel.swift
//  MessageAppWithAssistant
//
//  Created by 中山龍 on 2022/06/13.
//

import Foundation
import UIKit
import Combine

class ChatroomListViewModel: UseActivityIndicator {
    var activityIndicatorView = UIActivityIndicatorView()

    private var cancellables = Set<AnyCancellable>()

    var delegate: UIViewController? {
        didSet {
            self.tryToRoomListRequest()

            self.chatroomList.$roomlist
                .sink(receiveValue: { receiveList in
                    self.roomArray = receiveList
                    var tempDelegate = self.delegate as! ChatroomListViewController
                    tempDelegate.roomListTableView.reloadData()
                })
                .store(in: &self.cancellables)

            self.chatroomList.$isLoading
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
        }
    }

    @Published var roomArray = [RoomItem]()

    private var chatroomList = ChatroomList()

    private func tryToRoomListRequest() {
        chatroomList.tryToGetChatroomList()
    }
}
