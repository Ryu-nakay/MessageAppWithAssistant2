//
//  SignupViewController.swift
//  MessageAppWithAssistant
//
//  Created by 中山龍 on 2022/06/03.
//

import UIKit
import Combine

class SignupViewController: UIViewController {
    var viewModel = SignupViewModel()

    @IBOutlet weak var emailTextFIeld: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!

    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var passwordSecretButton: UIButton!
    @IBOutlet weak var confirmPasswordSecretButton: UIButton!
    @IBOutlet weak var loginTextButton: UIButton!

    @IBOutlet weak var passwordWarningLabel: UILabel!

    @IBOutlet weak var confirmPasswordWarningLabel: UILabel!
    
    // cancellablesの生成
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        // ViewTransition
        self.viewModel.viewController = self
        self.viewModel.initActivityIndicatorView(viewController: self)

        self.passwordWarningLabel.text = ""
        self.confirmPasswordWarningLabel.text = ""

        // パスワード隠しボタンの処理
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

        // 確認パスワード隠しボタンの処理
        self.viewModel.$isConfirmPasswordSecret
            .sink(
                receiveValue: { flag in
                    print("recieve flag")
                    self.confirmPasswordTextField.isSecureTextEntry = flag
                    if flag {
                        self.confirmPasswordSecretButton.setImage(UIImage(systemName: "circle"), for: .normal)
                    } else {
                        self.confirmPasswordSecretButton.setImage(UIImage(systemName: "circle.slash"), for: .normal)
                    }
                }
            )
            .store(in: &self.cancellables)

        // passwordTextFieldをviewModelに購読させる
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self.passwordTextField)
            .map { ($0.object as? UITextField)?.text  ?? "" }
            .eraseToAnyPublisher()
            .sink(receiveValue: { input in
                if input.count < 8 {
                    self.passwordWarningLabel.text = "8文字以上で設定してください"
                    self.passwordWarningLabel.textColor = .red
                } else if 20 < input.count {
                    self.passwordWarningLabel.text = "20文字以下で設定してください"
                    self.passwordWarningLabel.textColor = .red
                } else if input.count == 0 {
                    self.passwordWarningLabel.text = ""
                } else {
                    self.passwordWarningLabel.text = "OK"
                    self.passwordWarningLabel.textColor = .green
                }
            })
            .store(in: &cancellables)

        // confirmPasswordTextFieldをviewModelに購読させる
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self.confirmPasswordTextField)
            .map { ($0.object as? UITextField)?.text  ?? "" }
            .eraseToAnyPublisher()
            .sink(receiveValue: { input in
                if input.count < 8 {
                    self.confirmPasswordWarningLabel.text = "8文字以上で設定してください"
                    self.confirmPasswordWarningLabel.textColor = .red
                } else if 20 < input.count {
                    self.confirmPasswordWarningLabel.text = "20文字以下で設定してください"
                    self.confirmPasswordWarningLabel.textColor = .red
                } else if input.count == 0 {
                    self.passwordWarningLabel.text = ""
                } else {
                    self.confirmPasswordWarningLabel.text = "OK"
                    self.confirmPasswordWarningLabel.textColor = .green
                }
            })
            .store(in: &cancellables)


        /*
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(sender:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(sender:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
         */
    }

    // サインアップボタンの処理
    @IBAction func onTapSignupButton(_ sender: Any) {
        self.viewModel.onTapSignupButton(email: emailTextFIeld.text!, password: passwordTextField.text!, confirmPassword: confirmPasswordTextField.text!)
    }

    @IBAction func onTapPasswordSecretButton(_ sender: Any) {
        self.viewModel.isPasswordSecret.toggle()
    }
    
    @IBAction func onTapConfirmPasswordSecretButton(_ sender: Any) {
        self.viewModel.isConfirmPasswordSecret.toggle()
    }

    @IBAction func onTapLoginTextButton(_ sender: Any) {
        self.viewModel.onTapLoginTextButton()
    }

    // 枠外タップでキーボードを閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // キーボードが表示された時
    @objc private func keyboardWillShow(sender: NSNotification) {
        if confirmPasswordTextField.isFirstResponder {
            guard let userInfo = sender.userInfo else { return }
            let duration: Float = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).floatValue
            UIView.animate(withDuration: TimeInterval(duration), animations: { () -> Void in
                let transform = CGAffineTransform(translationX: 0, y: -150)
                self.view.transform = transform
            })
        }
    }

    // キーボードが閉じられた時
    @objc private func keyboardWillHide(sender: NSNotification) {
        guard let userInfo = sender.userInfo else { return }
        let duration: Float = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).floatValue
        UIView.animate(withDuration: TimeInterval(duration), animations: { () -> Void in
            self.view.transform = CGAffineTransform.identity
        })
    }
}
