//
//  LoginViewController.swift
//  myTwitterApp
//
//  Created by Harsh Trivedi on 10/31/16.
//  Copyright © 2016 Harsh Trivedi. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import OAuthSwift


class LoginViewController: UIViewController {
    var oauthswift: OAuthSwift?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButtin(_ sender: AnyObject) {
        
        
        /* OAuth1 code
 
        let oauthswift = OAuth1Swift(
            consumerKey:    "AOrpIA4KoED5E8OpsMbUZfjiz",
            consumerSecret: "xwKlKaLfOfia6Ny59uGFgrrA4Zfqu8fsJppArRs4s3uCxx1Pbo",
            requestTokenUrl: "https://api.twitter.com/oauth/request_token",
            authorizeUrl:    "https://api.twitter.com/oauth/authorize",
            accessTokenUrl:  "https://api.twitter.com/oauth/access_token"
        )
        self.oauthswift = oauthswift
        let handler = SafariURLHandler(viewController: self, oauthSwift: self.oauthswift!)
        handler.presentCompletion = {
            print("Safari presented")
        }
        handler.dismissCompletion = {
            print("Safari dismissed")
        }
        oauthswift.authorizeURLHandler = handler
        
        let _ = oauthswift.authorize(
            withCallbackURL: URL(string: "mytwitterapp://oath")!,
            success: { credential, response, parameters in
                print(credential.oauthToken)
                print(credential.oauthTokenSecret)
                print(parameters["user_id"])
                self.testTwitter(oauthswift)
            },
            failure: { error in
                print(error.description)
            }
        )
        /*
        let twitterClient = BDBOAuth1SessionManager(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "AOrpIA4KoED5E8OpsMbUZfjiz", consumerSecret: "xwKlKaLfOfia6Ny59uGFgrrA4Zfqu8fsJppArRs4s3uCxx1Pbo")
        
        twitterClient?.deauthorize()
        twitterClient?.
         */
    */
        
        TwitterApiManager.sharedInstance?.login(success: {
            if let myDelegate = UIApplication.shared.delegate as? AppDelegate {
                myDelegate.login()
            }
        }) { (error: Error) in
            print("error: \(error.localizedDescription)")
        }
    }
    
}

    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

