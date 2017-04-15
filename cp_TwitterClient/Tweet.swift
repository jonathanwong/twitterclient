//
//  Tweet.swift
//  cp_TwitterClient
//
//  Created by Jonathan Wong on 4/12/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import Foundation

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: Date?
    
    init(dictionary: [String: Any]) {
        user = User(dictionary: (dictionary["user"] as? Dictionary)!)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_as"] as? String
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        if createdAtString != nil {
            createdAt = formatter.date(from: createdAtString!)
        }
    }
    
    class func tweetsWithArray(array: [[String: Any]]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in array {
    tweets.append(Tweet(dictionary: dictionary))
        }
    
    return tweets
    }
}
