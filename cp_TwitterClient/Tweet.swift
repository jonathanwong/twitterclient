//
//  Tweet.swift
//  cp_TwitterClient
//
//  Created by Jonathan Wong on 4/12/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import Foundation
import SwiftMoment

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: Date?
    var id: UInt64
    
    init(dictionary: [String: Any]) {
        user = User(dictionary: (dictionary["user"] as? Dictionary)!)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        id = (dictionary["id"] as? UInt64)!
        
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

struct DateHelpers {
    static let SecondsPerDay = 86400
    
    static func timeFrom(date1: Date, date2: Date) -> String {
        let interval: TimeInterval = date2.timeIntervalSince(date1)
        let time = formatSecondsString(seconds: Int(interval))
        
        if time.hours < 1 {
            return "\(time.minutes)m"
        } else if time.hours < 24 && time.hours >= 1 {
            return "\(time.hours)h"
        } else {
            let days = Int(interval) / 86400
            return "\(days)d"
        }
    }
    
    static func formatSecondsString(seconds: Int) -> (hours: Int, minutes: Int, seconds: Int) {
        let hours = seconds / (60 * 60)
        let remainder = seconds % 3600
        let minutes = remainder / 60
        let seconds = remainder % 60
        
        return (hours, minutes, seconds)
    }

}
