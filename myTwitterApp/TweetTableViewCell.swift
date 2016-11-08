//
//  TweetTableViewCell.swift
//  myTwitterApp
//
//  Created by Harsh Trivedi on 11/1/16.
//  Copyright © 2016 Harsh Trivedi. All rights reserved.
//

import UIKit
import AFNetworking
protocol TweetDelegate: class
{
    func viewProfile(user: User?)
}
class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var userTwitterHandleLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetPostedTimeLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    
    @IBOutlet weak var replyTweetButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var user: User?
    weak var tweetDelegate: TweetDelegate!
    
    var tweet: Tweet! {
        didSet {
            tweetTextLabel.text = tweet.text!
            tweetPostedTimeLabel.text = tweet.display(date: tweet.timestamp!)
            retweetCountLabel.text = "\(tweet.retweetCount)"
            favoritesCountLabel.text = "\(tweet.favoritesCount)"
            self.user = tweet.user
            userImageView.setImageWith((tweet.user?.profileURL)!)
            userLabel.text = tweet.user?.name
            userTwitterHandleLabel.text = "@\((tweet.user?.screenname)!)"
        }
    }

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userImageView.layer.cornerRadius = 6
        userImageView.clipsToBounds = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleImageTap(recognizer:)))
        tap.cancelsTouchesInView = true
        tap.numberOfTapsRequired = 1;
        userImageView.addGestureRecognizer(tap)
        
        
       
    }
    func handleImageTap(recognizer : UITapGestureRecognizer)
    {
     print("imaged tab");
    tweetDelegate.viewProfile(user: user)

    }
    
    func setData(tweet: Tweet, tweetDelegate: TweetDelegate){
        self.tweet = tweet
        self.tweetDelegate = tweetDelegate
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
