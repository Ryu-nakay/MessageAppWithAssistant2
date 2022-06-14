//
//  ChatroomListViewModel.swift
//  MessageAppWithAssistant
//
//  Created by 中山龍 on 2022/06/13.
//

import Foundation
import UIKit

class ChatroomListViewModel: UseActivityIndicator {
    var activityIndicatorView = UIActivityIndicatorView()

    var delegate: UIViewController? {
        didSet {
            self.tryToRoomListRequest()
        }
    }

    private var chatroomList = ChatroomList()

    private func tryToRoomListRequest() {
        chatroomList.tryToGetChatroomList()
    }
}
