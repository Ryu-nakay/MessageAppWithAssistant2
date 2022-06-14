//
//  ChatroomListViewController.swift
//  MessageAppWithAssistant
//
//  Created by 中山龍 on 2022/06/04.
//

import UIKit

class ChatroomListViewController: UIViewController {

    var viewModel = ChatroomListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Rooms"

        self.viewModel.delegate = self
    }
}
