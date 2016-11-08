//
//  User.swift
//  myTwitterApp
//
//  Created by Harsh Trivedi on 10/31/16.
//  Copyright © 2016 Harsh Trivedi. All rights reserved.
//

import Foundation

class User{
    static let userLogoutNotification = NSNotification.Name(rawValue: "UserLogoutNotification");
    
    var name: String?
    var screenname: String?
    var profileURL: URL?
    var tagline: String?
    
    var dictionary: NSDictionary
    
    var followersCount: Int?
    var followingCount: Int?
    var tweetsCount: Int?
    
    
    //constructor for the class
    init(dictionary: NSDictionary) {
        
        self.dictionary = dictionary;
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        let profileURLString = dictionary["profile_image_url_https"] as? String
        if let profileURLString = profileURLString {
            profileURL = URL(string: profileURLString)
        }
        tagline = dictionary["description"] as? String
        
        followersCount = dictionary["followers_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
        tweetsCount = dictionary["statuses_count"] as? Int
        
    }
    
    static var _currentUser: User?
    
    class var currentUser: User?  {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? Data
                if let userData = userData {
                    let dictionary  = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
}
