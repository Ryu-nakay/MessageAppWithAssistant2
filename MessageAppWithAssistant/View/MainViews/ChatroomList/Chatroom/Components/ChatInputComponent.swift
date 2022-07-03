//
//  ChatInputComponent.swift
//  MessageAppWithAssistant
//
//  Created by 中山龍 on 2022/06/21.
//

import UIKit

class ChatInputComponent: UIView {

    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var inputTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var sendButton: NSLayoutConstraint!

    var roomInfo: RoomItem?

    override init(frame: CGRect) {
        super.init(frame: frame)

        nibInit()

        inputTextView.layer.cornerRadius = 10
        inputTextView.layer.borderColor = UIColor.blue.cgColor
        inputTextView.layer.borderWidth = 1
        // autoresizingMask = .flexibleHeight

        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.blue.cgColor


    }

    private func nibInit() {
        let nib = UINib(nibName: "ChatInputComponent", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }

        view.frame = self.bounds
        // view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    override var intrinsicContentSize: CGSize {
        return .zero
    }
     */


    @IBAction func onTapSendButton(_ sender: Any) {
        var messageSender = MessageSender()
        messageSender.send(roomId: self.roomInfo!.roomId, contents: inputTextView.text)
    }
}
