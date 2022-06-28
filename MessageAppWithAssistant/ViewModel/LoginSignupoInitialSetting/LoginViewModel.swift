//
//  LoginViewModel.swift
//  MessageAppWithAssistant
//
//  Created by 中山龍 on 2022/06/04.
//

import Foundation
import UIKit
import Combine


class LoginViewModel: UseActivityIndicator, ViewTransition {
    var viewController: UIViewController?
    
    // ローディングフラグ
    @Published var isLoading: Bool = false
    // ログインフラグ
    @Published var isLogin: Bool = false
    // 初期設定してあるかフラグ
    @Published var hasInformation: Bool = false

    @Published var isPasswordSecret: Bool = true

    @Published var passwordTextFieldText: String = ""

    // cancellablesの生成
    private var cancellables = Set<AnyCancellable>()

    var loginModel = LoginModel()



    // UseActivityIndicatorProtocol
    var activityIndicatorView = UIActivityIndicatorView()

    init() {
        // バインディング
        self.loginModel.$isLoading.assign(to: &self.$isLoading)
        self.loginModel.$isLogin.assign(to: &self.$isLogin)
        self.loginModel.$hasInformation.assign(to: &self.$hasInformation)

        self.$isLoading
            .sink( receiveValue: { value in
                    if value == true {
                        // ローディング中ならインジケータ表示
                        self.startLoadingIndicator()
                    } else {
                        // ローディング中でないならインジケーター非表示
                        self.stopLoadingIndicator()
                    }
                }
            )
            .store(in: &cancellables)

        self.$isLogin
            .sink( receiveValue: { value in
                if value {
                    if self.hasInformation {
                        self.transitionToChatroomListView(viewController: self.viewController!)
                    } else {
                        self.transitionToInitialSettingView(viewController: self.viewController!)
                    }
                }
            })
            .store(in: &cancellables)
    }

    // ログインボタンの処理
    func onTapLoginButton(email: String, password: String) {
        loginModel.tryToLogin(email: email, password: password)
    }

    // サインアップテキストボタンの処理
    func onTapSignupTextButton() {
        self.transitionToSignupView(viewController: self.viewController!)
    }
}

// パスワードのバリデーション
extension LoginViewModel {
    
}
