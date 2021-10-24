//
//  ActivityInfoTableViewCell.swift
//  Game Match
//
//  Created by Luke Shi on 8/12/21.
//

import UIKit

class ActivityInfoTableViewCell: UITableViewCell
{
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var favorateButton: UIButton!
    @IBOutlet weak var attendeesView: UIScrollView!
    
    var joinActivity: (() -> Void)?
    var shareActivity: (() -> Void)?
    var invite: (() -> Void)?
    var sendMessage: (() -> Void)?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        let totalAttendees = 18
        let contentHeight = attendeesView.bounds.height
        let contentWidth = (contentHeight + 5) * CGFloat(totalAttendees) - 5

        attendeesView.contentSize = CGSize(width: contentWidth,
                                           height: contentHeight)
        
        var currentViewOffset = CGFloat(0)
        for i in 0 ..< totalAttendees {
            let subview = UIImageView(frame: CGRect(x: currentViewOffset, y: 0, width: contentHeight, height: contentHeight))
            subview.image = UIImage(named: "soccerplayer\(i % 4)")
            subview.contentMode = .scaleAspectFill
            subview.layer.cornerRadius = contentHeight / 2
            subview.clipsToBounds = true
            attendeesView.addSubview(subview)

            currentViewOffset += contentHeight + 5
        }
    }
    
    func config(startTime: Date, endTime: Date, location: String)
    {
        dateLabel.text = startTime.display(format: "EEE, MMM d, yyyy")
        timeLabel.text = startTime.display(format: "h:mma") + " - " + endTime.display(format: "h:mma")
        locationLabel.text = location
    }
    
    @IBAction func joinAction(_ sender: Any)
    {
        joinActivity?()
    }
    
    @IBAction func favorateAction(_ sender: Any)
    {
        favorateButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
    }
    
    @IBAction func shareAction(_ sender: Any)
    {
        shareActivity?()
    }
    
    @IBAction func directionAction(_ sender: Any)
    {
        if let targetURL = URL(string: "http://maps.apple.com/?q=danville") {
            UIApplication.shared.open(targetURL)
        }
    }
    
    @IBAction func messageAction(_ sender: Any)
    {
        sendMessage?()
    }
    
    @IBAction func inviteAction(_ sender: Any)
    {
        invite?()
    }
}
