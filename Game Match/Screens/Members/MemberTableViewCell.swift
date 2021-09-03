//
//  MemberTableViewCell.swift
//  Game Match
//
//  Created by Luke Shi on 8/30/21.
//

import UIKit

class MemberTableViewCell: UITableViewCell
{
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconView.layer.cornerRadius = 25
        iconView.clipsToBounds = true
    }
    
    func config(icon: String, name: String, info: String, date: String) {
        iconView.image = UIImage(named: icon)
        nameLabel.text = name
        infoLabel.text = info
        dateLabel.text = date
    }
}
