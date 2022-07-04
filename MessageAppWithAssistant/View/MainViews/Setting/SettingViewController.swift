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
        let currentSettingItem = self.viewModel.settingItemsArray[indexPath.row]
        cell.textLabel?.text = currentSettingItem.rawValue
        cell.textLabel?.textColor = currentSettingItem.itemTextColor()
        return cell
    }

    // タップ時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentSettingItem = self.viewModel.settingItemsArray[indexPath.row]
        currentSettingItem.itemsAction(viewController: self)
        self.settingTableView.deselectRow(at: indexPath, animated: true)
    }
}

// テーブルのイベントを管理する
extension SettingViewController: UITableViewDelegate {

}
