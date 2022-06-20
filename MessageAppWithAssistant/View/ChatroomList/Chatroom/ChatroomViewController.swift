//
//  ChatroomViewController.swift
//  MessageAppWithAssistant
//
//  Created by 中山龍 on 2022/06/14.
//

import UIKit
import Combine

class ChatroomViewController: UIViewController {
    @IBOutlet weak var chatTableView: UITableView!
    var cancellables = Set<AnyCancellable>()
    
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
        self.chatTableView.dataSource = self
        self.chatTableView.delegate = self

        self.chatTableView.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatTableViewCell")
        self.chatTableView.register(UINib(nibName: "MyChatTableViewCell", bundle: nil), forCellReuseIdentifier: "MyChatTableViewCell")

        self.chatTableView.estimatedRowHeight = 90
        self.chatTableView.rowHeight = UITableView.automaticDimension
    }
}

extension ChatroomViewController: UITableViewDelegate {

}

extension ChatroomViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.chatList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myUserId = UserDefaults.standard.string(forKey: "userId")

        let currentChatData = self.viewModel.chatList[indexPath.row]

        if currentChatData.sendUserId != myUserId {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
            cell.messageLabel.text = "\(currentChatData.contents)"
            let date =  NSDate(timeIntervalSince1970: currentChatData.sendTime)
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            cell.dateLabel.text = "\(formatter.string(from: date as Date))"

            self.viewModel.tryToGetUserNamePublisher(userId: currentChatData.sendUserId)
                .sink(receiveCompletion: { result in
                    print("error")
                }, receiveValue: { userInfo in
                    DispatchQueue.main.async {
                        cell.userNameLabel.text = userInfo.userName
                    }
                })
                .store(in: &self.cancellables)
            
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyChatTableViewCell", for: indexPath) as! MyChatTableViewCell
            cell.messageLabel.text = "\(currentChatData.contents)"
            let date =  NSDate(timeIntervalSince1970: currentChatData.sendTime)
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            cell.dateLabel.text = "\(formatter.string(from: date as Date))"
            return cell
        }
    }
}
