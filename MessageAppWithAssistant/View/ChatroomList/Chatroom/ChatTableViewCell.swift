//
//  ChatTableViewCell.swift
//  MessageAppWithAssistant
//
//  Created by 中山龍 on 2022/06/14.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageBackgroundView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userIcon.layer.cornerRadius = 44/2
        
        self.messageLabel.adjustsFontSizeToFitWidth = true
        self.messageBackgroundView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
