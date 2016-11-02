//
//  TweetCreateViewController.swift
//  myTwitterApp
//
//  Created by Harsh Trivedi on 11/1/16.
//  Copyright © 2016 Harsh Trivedi. All rights reserved.
//

import UIKit
protocol TweetCreateViewControllerDelegate: class {
    func didCreateTweet(tweet: Tweet)
}

class TweetCreateViewController: UIViewController {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var user:User!
    weak var delegate: TweetCreateViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        
        userImageView.setImageWith(user.profileURL!)
        userNameLabel.text = user.name!
        userHandleLabel.text = "@\(user.screenname!)"
        
        userImageView.layer.cornerRadius = 6
        userImageView.clipsToBounds = true

        // Do any additional setup after loading the view.
    }

    @IBAction func onTweetCancel(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func OnTweetPost(_ sender: AnyObject) {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        
        let tweetDictionary: NSDictionary = [
            "id"   : Int(arc4random()),
            "user" : user.dictionary,
            "text" : tweetTextView.text,
            "created_at" : formatter.string(from: date)
        ]
        let tweet = Tweet(dictionary: tweetDictionary)
        
        // TODO: update the POST function to return the Tweet object
        TwitterApiManager.sharedInstance?.createTweet(status: tweetTextView.text, success: {
            self.delegate?.didCreateTweet(tweet: tweet)
            
            }, failure: { (error) in
                print(error)
        })
        
        dismiss(animated: true, completion: nil)
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
