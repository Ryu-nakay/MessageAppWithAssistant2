//
//  ChatroomListTableViewCell.swift
//  MessageAppWithAssistant
//
//  Created by 中山龍 on 2022/06/14.
//

import UIKit

class ChatroomListTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var roomNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.iconImage.layer.cornerRadius = 44/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
