//
//  Tweet.swift
//  myTwitterApp
//
//  Created by Harsh Trivedi on 10/31/16.
//  Copyright © 2016 Harsh Trivedi. All rights reserved.
//

import Foundation

class Tweet {
    var text: String?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var user: User? //user who posted the tweet
    
    //constructor for the class
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        if let timestampString = dictionary["created_at"] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
        }
        
        if let userData = dictionary["user"] as? NSDictionary {
            user = User(dictionary: userData)
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
    
    func display(date: Date) -> String {
        let resultFormatter = DateFormatter()
        resultFormatter.dateFormat = "MM/dd/yy"
        return resultFormatter.string(from: date)
    }
}
