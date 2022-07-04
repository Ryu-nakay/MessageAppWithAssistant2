//
//  SettingItemsEnum.swift
//  MessageAppWithAssistant
//
//  Created by 中山龍 on 2022/07/04.
//

import Foundation
import UIKit

enum SettingItem: String {
    case logout = "ログアウト"

    func itemTextColor() -> UIColor {
        switch self {
        case .logout:
            return UIColor.red
        default:
            return UIColor.black
        }
    }

    func itemsAction(viewController: UIViewController) {
        switch self {
        case .logout:
            self.logoutAction(viewController: viewController)
        }
    }

    // ログアウトタップ時の処理
    private func logoutAction(viewController: UIViewController) {
        let alertController = UIAlertController(title: "ログアウトしますか",
                                   message: "再度ログインが必要になります",
                                   preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "キャンセル",
                                       style: .default,
                                       handler: nil))
        alertController.addAction(UIAlertAction(title: "ログアウト",
                                                style: .destructive) { _ in
            // ログイン情報の削除
            UserDefaults.standard.removeObject(forKey: "userId")

            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextView = storyboard.instantiateViewController(withIdentifier: "LoginView") as! LoginViewController
            viewController.present(nextView, animated: false, completion: nil)
        })
        viewController.present(alertController, animated: true)
    }
}
