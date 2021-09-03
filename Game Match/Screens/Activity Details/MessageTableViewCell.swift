//
//  MessageTableViewCell.swift
//  Game Match
//
//  Created by Luke Shi on 8/14/21.
//

import UIKit

class MessageTableViewCell: UITableViewCell
{
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(icon: String, name: String, time: String, message: String) {
        iconView.image = UIImage(named: icon)
        nameLabel.text = name
        timeLabel.text = time
        messageLabel.text = message
    }
}
