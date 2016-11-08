//
//  UserHeaderTableViewCell.swift
//  myTwitterApp
//
//  Created by Harsh Trivedi on 11/7/16.
//  Copyright © 2016 Harsh Trivedi. All rights reserved.
//

import UIKit

class UserHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userHandleLabel: UILabel!
    
    @IBOutlet weak var userTweetsCountLabel: UILabel!
    
    @IBOutlet weak var userFollowingCountsLabel: UILabel!
    
    @IBOutlet weak var userFollowersCountLabel: UILabel!
    
    var user: User! {
        didSet {
            userImageView.setImageWith((user.profileURL)!)
            userNameLabel.text = user.name
            userHandleLabel.text = "@\((user.screenname)!)"
            
            userTweetsCountLabel.text = "\(user.tweetsCount!)"
            userFollowersCountLabel.text = "\(user.followersCount!)"
            userFollowingCountsLabel.text = "\(user.followingCount!)"
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
