//
//  TransitionViewProtocol.swift
//  MessageAppWithAssistant
//
//  Created by 中山龍 on 2022/06/07.
//

import Foundation
import UIKit

protocol ViewTransition {
    
}

extension ViewTransition {
    // ChatroomListViewへの遷移
    func transitionToChatroomListView(viewController: UIViewController) {
        let storyboard: UIStoryboard = UIStoryboard(name: "MainTabBar", bundle: nil)
        let nextView = storyboard.instantiateViewController(withIdentifier: "TabBarView") as! UITabBarController
        viewController.present(nextView, animated: false, completion: nil)

        webSocketConnecter.connect()
    }

    // サインアップ画面への遷移
    func transitionToSignupView(viewController: UIViewController) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Signup", bundle: nil)
        let nextView = storyboard.instantiateViewController(withIdentifier: "SignupView") as! SignupViewController
        viewController.present(nextView, animated: true, completion: nil)
    }

    // 初期設定画面への遷移
    func transitionToInitialSettingView(viewController: UIViewController) {
        let storyboard: UIStoryboard = UIStoryboard(name: "InitialSetting", bundle: nil)
        let nextView = storyboard.instantiateViewController(withIdentifier: "InitialSettingView") as! InitialSettingViewController
        viewController.present(nextView, animated: true, completion: nil)
    }

    func dismiss(viewController: UIViewController,animated: Bool) {
        viewController.dismiss(animated: animated)
    }
}
