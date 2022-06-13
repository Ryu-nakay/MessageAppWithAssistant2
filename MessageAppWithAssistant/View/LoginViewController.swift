//
//  LoginViewController.swift
//  MessageAppWithAssistant
//
//  Created by 中山龍 on 2022/06/03.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    // VM
    var viewModel = LoginViewModel()

    // cancellablesの生成
    private var cancellables = Set<AnyCancellable>()

    // Emailのフィールド
    @IBOutlet weak var emailTextField: UITextField!
    // Passwordのフィールド
    @IBOutlet weak var passwordTextField: UITextField!
    // サインアップ画面へ遷移する青文字ボタン
    @IBOutlet weak var signupTextButton: NSLayoutConstraint!

    @IBOutlet weak var passwordSecretButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // TransitionViewProtocol
        self.viewModel.delegate = self
        self.viewModel.delegate = self
        // アクティビティインジケータの初期化
        self.viewModel.initActivityIndicatorView()

        self.viewModel.$isPasswordSecret
            .sink(
                receiveValue: { flag in
                    print("recieve flag")
                    self.passwordTextField.isSecureTextEntry = flag
                    if flag {
                        self.passwordSecretButton.setImage(UIImage(systemName: "circle"), for: .normal)
                    } else {
                        self.passwordSecretButton.setImage(UIImage(systemName: "circle.slash"), for: .normal)
                    }
                }
            )
            .store(in: &self.cancellables)
    }

    // パスワードシークレットボタンの挙動
    @IBAction func onTapPasswordSecretButton(_ sender: Any) {
        self.viewModel.isPasswordSecret.toggle()
        print(self.viewModel.isPasswordSecret)

    }
    // ログインボタンの挙動
    @IBAction func onTapLoginButton(_ sender: Any) {
        self.viewModel.onTapLoginButton(email: emailTextField.text!, password: passwordTextField.text!)
    }

    // サインアップテキストボタンの挙動
    @IBAction func onTapSignupTextButton(_ sender: Any) {
        self.viewModel.onTapSignupTextButton()
    }

    // 枠外タップでキーボードを閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
