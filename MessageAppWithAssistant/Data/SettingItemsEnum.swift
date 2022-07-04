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

    func itemTextColor(itemType: SettingItem) -> UIColor {
        switch itemType {
        case .logout:
            return UIColor.red
        default:
            return UIColor.black
        }
    }
}
