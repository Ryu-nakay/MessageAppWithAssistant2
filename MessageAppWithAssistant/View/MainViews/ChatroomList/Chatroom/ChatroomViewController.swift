//
//  ChatroomViewController.swift
//  MessageAppWithAssistant
//
//  Created by 中山龍 on 2022/06/14.
//

import UIKit
import Combine
import RealmSwift
import Realm

class ChatroomViewController: UIViewController {
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var chatTableViewBottomConstraint: NSLayoutConstraint!
    var cancellables = Set<AnyCancellable>()
    
    var roomInfo: RoomItem? {
        didSet {
            navigationItem.title = roomInfo!.roomName
            // チャット内容のゲット
            self.viewModel.tryToGetChatData(roomId: self.roomInfo!.roomId, start: 0, count: 30)
            chatInputComponent.roomInfo = self.roomInfo
        }
    }

    var viewModel = ChatroomViewModel()

    var chatInputComponent: ChatInputComponent = {
        let view = ChatInputComponent()
        view.frame = .init(x: 0, y: 0, width: view.frame.width, height: 100)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel.delegate = self
        self.viewModel.view = self
        self.chatTableView.dataSource = self
        self.chatTableView.delegate = self

        self.chatTableView.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatTableViewCell")
        self.chatTableView.register(UINib(nibName: "MyChatTableViewCell", bundle: nil), forCellReuseIdentifier: "MyChatTableViewCell")

        self.chatTableView.estimatedRowHeight = 90
        self.chatTableView.rowHeight = UITableView.automaticDimension

        self.chatTableViewBottomConstraint.constant = -((inputAccessoryView?.frame.height ?? 0))
        view.layoutIfNeeded()
    }

    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }

    //MARK: KeyBoard
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let rect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        guard let keyboardHeight = rect?.size.height else {
            return
        }

        self.chatTableViewBottomConstraint.constant = -(keyboardHeight + 0) //(inputAccessoryView?.frame.height ?? 0))
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.chatTableViewBottomConstraint.constant = 0// -((inputAccessoryView?.frame.height ?? 0))
    }

    override var inputAccessoryView: UIView? {
        get {
            return chatInputComponent
        }
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    // 枠外タップでキーボードを閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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

            // 名前の適応
            let realm = try! Realm()
            realm.objects(UserInfo.self).filter(NSPredicate(format: "userId == %@", currentChatData.sendUserId))
                .publisher
                .sink(receiveCompletion: { _ in

                }, receiveValue: { info in
                    if info.count != 0 {
                        cell.userNameLabel.text = info[0].userName
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
