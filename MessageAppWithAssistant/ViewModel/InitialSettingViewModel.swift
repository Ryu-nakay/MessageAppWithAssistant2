//
//  InitialSettingViewModel.swift
//  MessageAppWithAssistant
//
//  Created by 中山龍 on 2022/06/07.
//

import Foundation
import UIKit
import Combine

class InitialSettingViewModel: UseActivityIndicator, ViewTransition {
    var delegate: UIViewController?
    
    // UseActivityIndicatorで使う
    var activityIndicatorView = UIActivityIndicatorView()
    
    var settingModel = SettingModel()

    // ローディングフラグ
    @Published var isLoading: Bool = false
    @Published var hasInformation = false

    // cancellablesの生成
    private var cancellables = Set<AnyCancellable>()

    init() {
        // isLoadingとisLoginをバインディング
        self.settingModel.$isLoading.assign(to: &self.$isLoading)
        self.settingModel.$hasInformation.assign(to: &self.$hasInformation)

        // isLoadingを購読
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

        // hasInformationを購読
        self.$hasInformation
            .sink(
                receiveValue: { value in
                    if value == true {
                        // チャットルームへ遷移
                        self.transitionToChatroomListView()
                    }
                }
            )
            .store(in: &cancellables)
    }


    // セーブボタンの処理
    func onTapSaveButton(userName: String, searchId: String) {
        self.settingModel.tryToInitialSetting(userName: userName, searchId: searchId)
    }
}
