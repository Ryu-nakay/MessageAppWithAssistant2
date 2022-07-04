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


    @IBOutlet weak var inputComponentsView: UIView!
    @IBOutlet weak var chatInputTextView: UITextView!
    @IBOutlet weak var chatInputTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var chatInputSendButton: UIButton!

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
        self.viewModel.view = self
        self.chatTableView.dataSource = self
        self.chatTableView.delegate = self
        self.chatInputTextView.delegate = self

        self.chatTableView.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatTableViewCell")
        self.chatTableView.register(UINib(nibName: "MyChatTableViewCell", bundle: nil), forCellReuseIdentifier: "MyChatTableViewCell")

        self.chatTableView.estimatedRowHeight = 90
        self.chatTableView.rowHeight = UITableView.automaticDimension

        self.chatInputTextView.layer.cornerRadius = 10
        self.chatInputTextView.layer.borderColor = UIColor.blue.cgColor
        self.chatInputTextView.layer.borderWidth = 1
        self.chatInputTextView.text = ""

        self.chatInputSendButton.isEnabled = false

        self.inputComponentsView.layer.borderWidth = 1
        self.inputComponentsView.layer.borderColor = UIColor.blue.cgColor

        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))

        // chatInputTextViewのテキストを購読し、ボタンを制御
        NotificationCenter.default.publisher(for: UITextView.textDidChangeNotification, object: self.chatInputTextView)
            .map { ($0.object as? UITextView)?.text ?? "" }
            .eraseToAnyPublisher()
            .sink(receiveValue: { input in
                self.chatInputSendButton.isEnabled = (input.count != 0)
            })
            .store(in: &cancellables)

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

        let duration: TimeInterval = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: duration, animations: {
            let transform = CGAffineTransform(translationX: 0, y: -rect!.size.height)
                self.view.transform = transform
            },completion:nil)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double)
        UIView.animate(withDuration: duration, animations:{
            self.view.transform = CGAffineTransform.identity
                },
                    completion:nil)
    }

    @IBAction func onTapChatInputSendButton(_ sender: Any) {
        var messageSender = MessageSender()
        messageSender.send(roomId: self.roomInfo!.roomId, contents: self.chatInputTextView.text)
        self.chatInputTextView.text = ""
        self.chatInputSendButton.isEnabled = false
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

            // 名前の適用
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

extension ChatroomViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let maxHeight = 100.0  // 入力フィールドの最大サイズ
        print("\(chatInputTextView.frame.size.height.native)")

        if(chatInputTextView.frame.size.height.native <= maxHeight) {
            let size:CGSize = chatInputTextView.sizeThatFits(chatInputTextView.frame.size)
            if(size.height < maxHeight) {
                chatInputTextViewHeight.constant = size.height
                print("textViewDidChange is setting \(size.height)")
            }
        }
    }
}
