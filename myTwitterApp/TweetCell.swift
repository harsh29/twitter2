//
//  TweetCell.swift
//  myTwitterApp
//
//  Created by Harsh Trivedi on 11/7/16.
//  Copyright © 2016 Harsh Trivedi. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    var tweet: Tweet! {
        didSet {
            tweetTextLabel.text = tweet.text!
            
            timeStampLabel.text = tweet.display(date: tweet.timestamp!)
            retweetCountLabel.text = "\(tweet.retweetCount)"
            likeCountLabel.text = "\(tweet.favoritesCount)"
            userImageView.setImageWith((tweet.user?.profileURL)!)
            userNameLabel.text = tweet.user?.name
            userHandleLabel.text = "@\((tweet.user?.screenname)!)"
        }
    }
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!

    @IBOutlet weak var likeButton: UIImageView!
    @IBOutlet weak var retweetButton: UIImageView!
    @IBOutlet weak var replyButton: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userImageView.layer.cornerRadius = 6
        userImageView.clipsToBounds = true
        
        tweetTextLabel.sizeToFit()
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
