//
//  ChatroomListViewController.swift
//  MessageAppWithAssistant
//
//  Created by 中山龍 on 2022/06/04.
//

import UIKit

class ChatroomListViewController: UIViewController {

    @IBOutlet weak var roomListTableView: UITableView!

    var viewModel = ChatroomListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Rooms"

        self.viewModel.delegate = self

        // アクティビティインジケータの初期化
        self.viewModel.initActivityIndicatorView()

        // ↓追加　<tableview初期設定>
        self.roomListTableView.frame = view.frame
        self.roomListTableView.dataSource = self
        self.roomListTableView.delegate = self
        self.roomListTableView.tableFooterView = UIView(frame: .zero)
        

        self.roomListTableView.register(UINib(nibName: "ChatroomListTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomRoomCell")
    }
}

extension ChatroomListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.roomArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomRoomCell", for: indexPath) as! ChatroomListTableViewCell
        cell.roomNameLabel.text = self.viewModel.roomArray[indexPath.row].roomName
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        performSegue(withIdentifier: "ToChatroomSegue", sender: indexPath.row)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "ToChatroomSegue" {
            if let nextVC = segue.destination as? ChatroomViewController {
                let index = sender as? Int
                nextVC.roomInfo = self.viewModel.roomArray[index!]
            }
        }
    }
}

extension ChatroomListViewController: UITableViewDelegate {

}
