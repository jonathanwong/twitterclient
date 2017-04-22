//
//  User.swift
//  cp_TwitterClient
//
//  Created by Jonathan Wong on 4/12/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let UserDidLoginNotification = "UserDidLoginNotification"
let UserDidLogoutNotification = "UserDidLogoutNotification"

class User: NSObject {
    var name: String?
    var screenname: String?
    var id: UInt64?
    var profileImageUrl: String?
    var tagline: String?
    var backgroundImageUrl: String?
    var dictionary: Dictionary<String, Any>
    var countFollowers: Int?
    var countFollowing: Int?
    var countTweets: Int?
    
    init(dictionary: Dictionary<String, Any>) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        id = (dictionary["id"] as? UInt64)!
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
        backgroundImageUrl = dictionary["profile_background_image_url"] as? String
        countFollowers = (dictionary["followers_count"] as? Int) ?? 0
        countFollowing = (dictionary["following"] as? Int) ?? 0
        countTweets = (dictionary["statuses_count"] as? Int) ?? 0
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NotificationCenter.default.post(name: NSNotification.Name(UserDidLogoutNotification), object: nil, userInfo: nil)
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                var data = UserDefaults.standard.object(forKey: currentUserKey) as? Data
                if data != nil {
                    do {
                        let dictionary = try! JSONSerialization.jsonObject(with: data!, options: []) as! Dictionary<String, Any>
                        _currentUser = User(dictionary: dictionary)
                    } catch {
                        
                    }
                }
            }
            return _currentUser
        } set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                do {
                    var data = try JSONSerialization.data(withJSONObject: user?.dictionary, options: .prettyPrinted)
                    UserDefaults.standard.set(data, forKey: currentUserKey)
                } catch {
                    
                }
                
            } else {
                UserDefaults.standard.removeObject(forKey: currentUserKey)
            }
            
            UserDefaults.standard.synchronize()
        }
    }
}

