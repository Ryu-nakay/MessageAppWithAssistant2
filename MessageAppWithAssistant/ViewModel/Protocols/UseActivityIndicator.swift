//
//  UseActivityIndicator.swift
//  MessageAppWithAssistant
//
//  Created by 中山龍 on 2022/06/06.
//

import Foundation
import UIKit

protocol UseActivityIndicator {
    var activityIndicatorView: UIActivityIndicatorView { get set }

    var delegate: UIViewController? { get set }

    func initActivityIndicatorView()

    func startLoadingIndicator()
    func stopLoadingIndicator()
}

extension UseActivityIndicator {
    func initActivityIndicatorView() {
        self.activityIndicatorView.center = self.delegate!.view.center
        self.activityIndicatorView.style = .whiteLarge
        self.activityIndicatorView.color = .white
        self.activityIndicatorView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.activityIndicatorView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.delegate!.view.addSubview(self.activityIndicatorView)
    }

    func startLoadingIndicator() {
        self.activityIndicatorView.startAnimating()
    }

    func stopLoadingIndicator() {
        self.activityIndicatorView.stopAnimating()
    }
}
