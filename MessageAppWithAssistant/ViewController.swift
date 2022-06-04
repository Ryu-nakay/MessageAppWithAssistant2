//
//  ViewController.swift
//  MessageAppWithAssistant
//
//  Created by 中山龍 on 2022/06/03.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // ①storyboardのインスタンス取得
        let storyboard: UIStoryboard = self.storyboard!

        // ②遷移先ViewControllerのインスタンス取得
        let nextView = storyboard.instantiateViewController(withIdentifier: "LoginView") as! LoginViewController

        // ③画面遷移
        self.present(nextView, animated: true, completion: nil)
    }
}

