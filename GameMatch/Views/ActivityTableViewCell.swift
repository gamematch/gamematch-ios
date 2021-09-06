//
//  ActivityTableViewCell.swift
//  Game Match
//
//  Created by Luke Shi on 8/12/21.
//

import UIKit

class ActivityTableViewCell: UITableViewCell
{
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        iconView.layer.cornerRadius = iconView.bounds.width / 2
    }

    func config(icon: UIImage?, title: String, details: String, count: String? = nil) {
        iconView.image = icon
        titleLabel.text = title
        detailsLabel.text = details
        countLabel?.text = count
    }
}
