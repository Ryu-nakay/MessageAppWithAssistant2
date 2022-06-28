//
//  SignupViewModel.swift
//  MessageAppWithAssistant
//
//  Created by 中山龍 on 2022/06/06.
//

import Foundation
import Combine
import UIKit

class SignupViewModel: UseActivityIndicator, ViewTransition {
    var viewController: UIViewController?

    // ローディング中フラグ
    @Published var isLoading: Bool = false
    // ログインフラグ
    @Published var isLogin: Bool = false

    // ログインモデル
    var loginModel = LoginModel()

    // UseActivityIndicatorProtocolで使うインジケータ
    var activityIndicatorView = UIActivityIndicatorView()


    @Published var isPasswordSecret: Bool = true
    @Published var isConfirmPasswordSecret: Bool = true

    // cancellablesの生成
    private var cancellables = Set<AnyCancellable>()

    
    init() {
        // バインディングの設定
        self.dataBundingFromLoginModelToSelf()
        // isLoadingの購読開始
        self.startIndicatorProcess()
        // isLoginの購読開始
        self.startIsLoginObserving()
    }
}


// バインディング処理
extension SignupViewModel {
    // LoginModelからのデータバインディング
    func dataBundingFromLoginModelToSelf() {
        // isLoadingとisLoginをバインディング
        self.loginModel.$isLoading.assign(to: &self.$isLoading)
        self.loginModel.$isLogin.assign(to: &self.$isLogin)
    }

    // isLoadingの購読をしてインジケータの制御を監視する
    func startIndicatorProcess() {
        self.$isLoading
            .sink(
                receiveValue: { value in
                    if value == true {
                        // ローディング中ならインジケーター表示
                        self.startLoadingIndicator()
                    } else {
                        // ローディング中でないならインジケーター非表示
                        self.stopLoadingIndicator()
                    }
                }
            )
            .store(in: &cancellables)
    }

    // isLoginの監視を開始し、trueになったら遷移
    func startIsLoginObserving() {
        self.$isLogin.sink(receiveValue: { value in
            if value {
                // ログインしたなら初期設定画面へ遷移
                self.transitionToInitialSettingView(viewController: self.viewController!)
            }
        })
        .store(in: &cancellables)
    }

    

}



// ボタンの処理
extension SignupViewModel {
    // サインアップボタンの処理
    func onTapSignupButton(email: String, password: String, confirmPassword: String) {
        if password != confirmPassword {
            let alert = UIAlertController(title: "エラー", message: "パスワードと再入力パスワードの値が異なります。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.viewController!.present(alert, animated: true, completion: nil)
        } else {
            // サインアップの実行
            self.loginModel.tryToSignup(email: email, password: password)
        }
    }

    // ログインテキストボタンの処理
    func onTapLoginTextButton() {
        self.viewController!.dismiss(animated: true)
    }
}
