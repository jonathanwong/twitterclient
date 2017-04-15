//
//  TweetTableViewCell.swift
//  cp_TwitterClient
//
//  Created by Jonathan Wong on 4/14/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import UIKit
import SwiftMoment

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.layer.cornerRadius = 5.0
        avatarImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    var tweet: Tweet! {
        didSet {
            if let user = tweet.user {
                avatarImageView.setImageWith(URL(string: (user.profileImageUrl)!)!)
                nameLabel.text = user.name
                
                if let createdAt = tweet.createdAt {
                    let duration = DateHelpers.timeFrom(date1: Date(), date2: createdAt)
                    screennameLabel.text = "@\(user.screenname!) \(duration)"
                }
                
                tweetLabel.text = tweet.text
            }
            
        }
    }
}
