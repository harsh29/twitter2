//
//  TweetDetaialViewController.swift
//  myTwitterApp
//
//  Created by Harsh Trivedi on 11/1/16.
//  Copyright © 2016 Harsh Trivedi. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
   
    @IBOutlet weak var userHandleLabel: UILabel!
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var timeStampLabel: UILabel!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    @IBOutlet weak var favoritesCountLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var favoriteButton: UIButton!
   
    
    @IBAction func onBackButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func onFavoriteButton(_ sender: AnyObject) {
        if !liked {
            self.tweet.favoritesCount += 1
            self.favoritesCountLabel.text = "\(self.tweet.favoritesCount)"
            self.favoriteButton.setImage(UIImage(named: "likeRed"), for: .normal)

            liked = true
        }
    }
    
   
    @IBAction func OnRetweet(_ sender: AnyObject) {
        if !retweeted {
            self.tweet.retweetCount += 1
            self.retweetCountLabel.text = "\(self.tweet.retweetCount)"
            self.retweetButton.setImage(UIImage(named: "retweetBlue"), for: .normal)
            
            retweeted = true
        }
    }
    
    
    
    
    @IBAction func OnReplyTweet(_ sender: AnyObject) {
        
    }
    
    
    var tweet: Tweet!
    var retweeted = false
    var liked = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tweetTextLabel.text = tweet.text!
        timeStampLabel.text = tweet.display(date: tweet.timestamp!)
        retweetCountLabel.text = "\(tweet.retweetCount)"
        favoritesCountLabel.text = "\(tweet.favoritesCount)"
        
        userImageView.setImageWith((tweet.user?.profileURL)!)
        userNameLabel.text = tweet.user?.name
        userHandleLabel.text = "@\((tweet.user?.screenname)!)"
        
        userImageView.layer.cornerRadius = 6
        userImageView.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
