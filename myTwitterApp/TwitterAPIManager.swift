//
//  TwitterAPIManager.swift
//  myTwitterApp
//
//  Created by Harsh Trivedi on 10/31/16.
//  Copyright © 2016 Harsh Trivedi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Locksmith
import BDBOAuth1Manager

enum TwitterAPIManagerError: Error{
    case network(error: Error)
    case apiProvidedError(reason: String)
    case authCouldNot(reason: String)
    case authLost(reason: String)
    case objectSerialization(reason: String)
}

class  TwitterApiManager: BDBOAuth1SessionManager{
    static let sharedInstance = TwitterApiManager(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "AOrpIA4KoED5E8OpsMbUZfjiz", consumerSecret: "xwKlKaLfOfia6Ny59uGFgrrA4Zfqu8fsJppArRs4s3uCxx1Pbo")
    
    var loginSuccess:(() -> ())?
    var loginFailure: ((Error) -> ())?
   
    func login(success: @escaping () -> (), failure: @escaping (Error) ->()){
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "mytwitterapp://oath"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
            
            guard let token = requestToken else{
                print("Wait... I am in success but token is still nil")
                return
            }
            
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token.token!)")!
            UIApplication.shared.open(url as URL);
            
            }, failure: { (error:Error?) -> Void in
                print("error: \(error?.localizedDescription)")
        })

    }
    
    func logout(){
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(name: User.userLogoutNotification, object: nil)
    }
    
    func handleOpenURL(url: URL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken!, success: { (accessToken: BDBOAuth1Credential?) in
            
            print("I got an access token")
            
            self.getCurrentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
                print("User logged in")
                
                }, failure: { (error: Error) in
                    print("error: \(error.localizedDescription)")
                    self.loginFailure?(error)
            })
            
            }, failure: { (error: Error?) in
                print("error: \(error?.localizedDescription)")
                self.loginFailure?(error!)
        })
    }
    
    func getHomeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task :URLSessionDataTask, response: Any?) in
            
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            print("\nI got tweets \nCount:\(tweets.count)\n")
            success(tweets)
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
        })
    }
    
    func getUserTimeline(screenName: String, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        
        get("1.1/statuses/user_timeline.json", parameters: ["screen_name": screenName], progress: nil, success: { (task :URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            print("\nI got user tweets \nCount:\(tweets.count)\n")
            success(tweets)
            
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
        })
    }
    
    func getMentionsTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        
        get("1.1/statuses/mentions_timeline.json", parameters: nil, progress: nil, success: { (task :URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            print("\nI got user mentions \nCount:\(tweets.count)\n")
            success(tweets)
            
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
        })
    }
    
    
    func getCurrentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
    
            print("I got a user")
            
            success(user)
            
            }, failure: { (task: URLSessionTask?, error: Error) in
                failure(error)
        })
    }
    
    func favoriteTweet(id: Int, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        
        let params: [String : AnyObject] = ["id": id as AnyObject]
        print(params)
        
        post("1.1/favorites/create.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
            
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                print(error)
                failure(error)
        })
    }
    
    func retweetTweet(id: Int, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        
        let params: [String : AnyObject] = ["id": id as AnyObject]
        
        post("1.1/statuses/retweet/\(id).json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
            
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                print(error)
                failure(error)
        })
    }
    
    func createTweet(status: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        
        let params: [String : AnyObject] = ["status": status as AnyObject]
        
        post("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
            
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                print(error)
                failure(error)
        })
    }
    
    
    /*
    Trying to acheive success using OAuthSwift, giving up, but want to explore this route in future,
    // hence this code continues to exist
 
    var isLoadingOAuthToken: Bool = false
    var OAuthTokenCompletionHandler:((Error?) -> Void)?
    //Will be using this later.
    
    var OAuthToken: String? {
        set {
            guard let newValue = newValue else {
                let _ = try? Locksmith.deleteDataForUserAccount(userAccount: "twitter")
                return
            }
            guard let _ = try? Locksmith.updateData(data: ["token": newValue],
                                                    forUserAccount: "twitter") else {
                                                        let _ = try? Locksmith.deleteDataForUserAccount(userAccount: "twitter")
                                                        return
            }
        }
        get {
            // try to load from keychain
            let dictionary = Locksmith.loadDataForUserAccount(userAccount: "twitter")
            return dictionary?["token"] as? String
        }
    }
 */
}

