//
//  SceneDelegate.swift
//  MessageAppWithAssistant
//
//  Created by 中山龍 on 2022/06/03.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }

        let windows = UIWindow(windowScene: scene as! UIWindowScene)
        self.window = windows
        windows.makeKeyAndVisible()


        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        let chatroomsb = UIStoryboard(name: "MainTabBar", bundle: Bundle.main)

        // 自動ログイン機能
        if let _ = UserDefaults.standard.string(forKey: "userId") {
            let vc = chatroomsb.instantiateViewController(withIdentifier: "TabBarView")
            window!.rootViewController = vc
            webSocketConnecter.connect()
        } else {
            let vc = sb.instantiateViewController(withIdentifier: "LoginView")
            window!.rootViewController = vc
        }


        /*
        if 条件式 {
            let vc = sb.instantiateViewController(withIdentifier: ストーリーボードID)
            window!.rootViewController = vc
        } else {
            let vc = sb.instantiateViewController(withIdentifier: ストーリーボードID)
            window!.rootViewController = vc
        }
         */
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

