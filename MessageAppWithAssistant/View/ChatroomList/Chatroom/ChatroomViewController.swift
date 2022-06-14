//
//  ChatroomViewController.swift
//  MessageAppWithAssistant
//
//  Created by 中山龍 on 2022/06/14.
//

import UIKit

class ChatroomViewController: UIViewController {

    var roomInfo: RoomItem? {
        didSet {
            navigationItem.title = roomInfo!.roomName
            // チャット内容のゲット
            self.viewModel.tryToGetChatData(roomId: self.roomInfo!.roomId, start: 0, count: 30)
        }
    }

    var viewModel = ChatroomViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel.delegate = self
    }
}
