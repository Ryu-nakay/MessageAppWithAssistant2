//
//  TransitionViewProtocol.swift
//  MessageAppWithAssistant
//
//  Created by 中山龍 on 2022/06/07.
//

import Foundation
import UIKit

protocol ViewTransition {
    // ViewController
    var delegate: UIViewController? { get set }
    // ChatroomListViewへの遷移
    func transitionToChatroomListView()
    // サインアップ画面への遷移
    func transitionToSignupView()
    
}

extension ViewTransition {
    // ChatroomListViewへの遷移
    func transitionToChatroomListView() {
        let storyboard: UIStoryboard = UIStoryboard(name: "MainTabBar", bundle: nil)
        let nextView = storyboard.instantiateViewController(withIdentifier: "TabBarView") as! UITabBarController
        self.delegate!.present(nextView, animated: false, completion: nil)

        webSocketConnecter.connect()
    }

    // サインアップ画面への遷移
    func transitionToSignupView() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Signup", bundle: nil)
        let nextView = storyboard.instantiateViewController(withIdentifier: "SignupView") as! SignupViewController
        self.delegate!.present(nextView, animated: true, completion: nil)
    }

    // 初期設定画面への遷移
    func transitionToInitialSettingView() {
        let storyboard: UIStoryboard = UIStoryboard(name: "InitialSetting", bundle: nil)
        let nextView = storyboard.instantiateViewController(withIdentifier: "InitialSettingView") as! InitialSettingViewController
        self.delegate!.present(nextView, animated: true, completion: nil)
    }

    func dismiss(animated: Bool) {
        self.delegate!.dismiss(animated: animated)
    }
}
