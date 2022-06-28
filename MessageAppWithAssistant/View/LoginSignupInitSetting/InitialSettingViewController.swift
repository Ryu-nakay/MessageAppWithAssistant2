//
//  InitialSettingViewController.swift
//  MessageAppWithAssistant
//
//  Created by 中山龍 on 2022/06/07.
//

import UIKit

class InitialSettingViewController: UIViewController {
    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userIdentifierTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!

    var viewModel = InitialSettingViewModel()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.viewController = self

        self.viewModel.initActivityIndicatorView(viewController: self)
    }

    @IBAction func onTapSaveButton(_ sender: Any) {
        self.viewModel.onTapSaveButton(userName: userNameTextField.text!, searchId: userIdentifierTextField.text!)
    }

    // 枠外タップでキーボードを閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
