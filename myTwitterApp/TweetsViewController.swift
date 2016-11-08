//
//  TweetsViewController.swift
//  myTwitterApp
//
//  Created by Harsh Trivedi on 11/1/16.
//  Copyright © 2016 Harsh Trivedi. All rights reserved.
//

import UIKit


class TweetsViewController: UIViewController, TweetDelegate {

    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()

    var tweets = [Tweet]()
    var profileSegueUser: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Set up the tableView.
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 125
        
        // Create a UIRefreshControl and add it to the tableView.
        // init refresh control
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        /*
        refreshControl.addTarget(
            self, action: #selector(refreshControlAction(_:)),
            for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        */
        
        getTweets(refresh:false)
        
        
        
    }
    
    func viewProfile(user: User?)
    {
        self.profileSegueUser = user!
        performSegue(withIdentifier: "ShowProfileSegue", sender: self)
    }
    

    @IBAction func onUserImageTap(_ sender: UITapGestureRecognizer) {
        
        if sender.state == .ended
        {
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(_ sender: AnyObject) {
        TwitterApiManager.sharedInstance?.logout()
    }
    
    func getTweets(refresh: Bool) {
        TwitterApiManager.sharedInstance?.getHomeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            for tweet in tweets {
                print(tweet.text!)
            }
            }, failure: { (error: Error) in
                print(error.localizedDescription)
        })
        
        if refresh {
            self.refreshControl.endRefreshing()
        }
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        self.getTweets(refresh: true)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowDetailTweet" {
            let tweet = sender as! Tweet
            let navigationController = segue.destination as! UINavigationController
            let tweetDetailVC = navigationController.topViewController as! TweetDetailViewController
            
            tweetDetailVC.tweet = tweet
        }
        else if segue.identifier == "CreateTweet" {
            let navigationController = segue.destination as! UINavigationController
            let tweetCreateVC = navigationController.topViewController as! TweetCreateViewController
            
            tweetCreateVC.user = User.currentUser
            tweetCreateVC.delegate = self
        }
        else if segue.identifier == "showProfileTweet" {
            let navigationController = segue.destination as! UINavigationController
            let profileVC = navigationController.topViewController as! ProfileViewController
            profileVC.user = profileSegueUser;
        }
    }
 
}

//Table view method implementation
extension TweetsViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetTableViewCell
        
        cell.setData(tweet: tweets[indexPath.row], tweetDelegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let tweet = tweets[indexPath.row]
        self.performSegue(withIdentifier: "ShowDetailTweet", sender: tweet)
    }

}

extension TweetsViewController: TweetCreateViewControllerDelegate {
    func didCreateTweet(tweet: Tweet) {
        tweets.insert(tweet, at: 0)
        tableView.reloadData()
    }
}
