//
//  MyChatTableViewCell.swift
//  MessageAppWithAssistant
//
//  Created by 中山龍 on 2022/06/17.
//

import UIKit

class MyChatTableViewCell: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageBackgroundView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.messageLabel.adjustsFontSizeToFitWidth = true
        self.messageBackgroundView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
