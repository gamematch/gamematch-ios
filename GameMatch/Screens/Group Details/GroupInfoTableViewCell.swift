//
//  GroupInfoTableViewCell.swift
//  Game Match
//
//  Created by Luke Shi on 8/28/21.
//

import UIKit

class GroupInfoTableViewCell: UITableViewCell
{
    @IBOutlet weak var membersView: UIScrollView!
    
    var newEvent: (() -> Void)?
    var showMembers: (() -> Void)?
    var showEvents: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        let totalMembers = 12
        let contentHeight = membersView.bounds.height
        let contentWidth = (contentHeight + 5) * CGFloat(totalMembers) - 5

        membersView.contentSize = CGSize(width: contentWidth,
                                           height: contentHeight)
        
        var currentViewOffset = CGFloat(0)
        for i in 0 ..< totalMembers {
            let subview = UIImageView(frame: CGRect(x: currentViewOffset, y: 0, width: contentHeight, height: contentHeight))
            subview.image = UIImage(named: "soccerplayer\(i % 4)")
            subview.contentMode = .scaleAspectFill
            subview.layer.cornerRadius = contentHeight / 2
            subview.clipsToBounds = true
            membersView.addSubview(subview)

            currentViewOffset += contentHeight + 5
        }
    }
    
    @IBAction func newEventAction(_ sender: Any) {
        newEvent?()
    }
    
    @IBAction func allMembersAction(_ sender: Any) {
        showMembers?()
    }
    
    @IBAction func allEventsAction(_ sender: Any) {
        showEvents?()
    }
    
    @IBAction func directionAction(_ sender: Any) {
        if let targetURL = URL(string: "http://maps.apple.com/?q=danville") {
            UIApplication.shared.open(targetURL)
        }
    }
}
