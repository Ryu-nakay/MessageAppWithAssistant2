//
//  SettingViewController.swift
//  MessageAppWithAssistant
//
//  Created by 中山龍 on 2022/07/04.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var settingTableView: UITableView!

    var viewModel = SettingViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Setting"

        self.settingTableView.frame = view.frame
        self.settingTableView.dataSource = self
        self.settingTableView.delegate = self
        self.settingTableView.tableFooterView = UIView(frame: .zero)
    }
}

extension SettingViewController: UITableViewDataSource {

    // セクション毎の行数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.settingItemsArray.count
    }

    // 各行に表示するセルを返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
        cell.textLabel?.text = self.viewModel.settingItemsArray[indexPath.row].rawValue
        cell.textLabel?.textColor = self.viewModel.settingItemsArray[indexPath.row].itemTextColor(itemType: self.viewModel.settingItemsArray[indexPath.row])
        return cell
    }
}

// テーブルのイベントを管理する
extension SettingViewController: UITableViewDelegate {

}
