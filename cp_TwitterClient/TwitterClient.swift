//
//  TwitterClient.swift
//  cp_TwitterClient
//
//  Created by Jonathan Wong on 4/11/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import Foundation
import BDBOAuth1Manager

let twitterConsumerKey = "DLKVpSrck3DkDjFfNJCveChIR"
let twitterConsumerSecret = "9UZPTtrzLhJsG2I1XwcC8mAtnVALuSrWWZMnbaTtYoUguuBqHo"
let twitterBaseUrl = URL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    
    var loginCompletion: ((_ user: User?, _ error: Error?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseUrl!, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance!
    }
    
    func loginWithCompletion(completion: @escaping (_ user: User?, _ error: Error?) -> ()) {
        loginCompletion = completion
        
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestToken(withPath: "oauth/request_token",
                                                       method: "GET",
                                                       callbackURL: URL(string: "cptwitterdemo://oauth"),
                                                       scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
                                                        print("got token")
                                                        if let token = requestToken?.token {
                                                            let authURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)")
                                                            UIApplication.shared.open(authURL!, options: [:], completionHandler: nil)
                                                        }
                                                        
        }) { (error: Error?) in
            self.loginCompletion?(nil, error)
        }
    }
    
    func openURL(url: URL) {
        if let query = url.query {
            let requestToken = BDBOAuth1Credential(queryString: query)
            TwitterClient.sharedInstance.fetchAccessToken(withPath: "oauth/access_token",
                                                          method: "POST",
                                                          requestToken: requestToken,
                                                          success: { (accessToken) in
                                                            print("got access token")
                                                            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                                                            
                                                            TwitterClient.sharedInstance.get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: {
                                                                (operation: URLSessionDataTask, response: Any?) in
                                                                print("user: \(response)")
                                                                let user = User(dictionary: response as! Dictionary<String, Any>)
                                                                User.currentUser = user
                                                                self.loginCompletion?(user, nil)
                                                            }, failure: { (operation: URLSessionDataTask?, error: Error) in
                                                                self.loginCompletion?(nil, error)
                                                            })
                                                            
                                                            TwitterClient.sharedInstance.get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: {
                                                                (operation: URLSessionDataTask, response: Any?) in
                                                                //                                                                print("user: \(response)")
                                                                var tweets = Tweet.tweetsWithArray(array: response as! [[String: Any]])
                                                                for tweet in tweets {
                                                                    print(tweet.text)
                                                                }
                                                            }, failure: { (operation: URLSessionDataTask?, error: Error) in
                                                                print(error)
                                                            })
            }, failure: { (error: Error?) in
               self.loginCompletion?(nil, error)
            })
        }
    }
    
    func homeTimelineWithParams(params: [String: AnyObject]?, completion: @escaping (_ tweets: [Tweet]?, _ error: Error?) -> ()) {
        print("calling hometimeline------------------------")
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: {
            (operation: URLSessionDataTask, response: Any?) in
            let tweets = Tweet.tweetsWithArray(array: response as! [[String: Any]])
            print("\(tweets.count)")
            for tweet in tweets {
                print(tweet.text)
            }
            completion(tweets, nil)
        }, failure: { (operation: URLSessionDataTask?, error: Error) in
            print(error)
            completion(nil, error)
        })

    }
}
