//
//  TweetDetailViewController.swift
//  cp_TwitterClient
//
//  Created by Jonathan Wong on 4/14/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let user = tweet.user {
            avatarImageView.setImageWith(URL(string: user.profileImageUrl!)!)
            usernameLabel.text = user.name
            screennameLabel.text = "@\(user.screenname!)"
            tweetLabel.text = tweet.text
        }
        
        let retweet = "🐤"
        retweetButton.setTitle(retweet, for: .normal)
        
        let favorite = "♥️"
        favoriteButton.setTitle(favorite, for: .normal)
        
        let reply = "📣"
        replyButton.setTitle(reply, for: .normal)
        
        
        
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
    @IBAction func retweetPressed(_ sender: Any) {
        TwitterClient.sharedInstance.retweetTweet(id: tweet.id)
    }

    
    @IBAction func favoritePressed(_ sender: Any) {
        TwitterClient.sharedInstance.favoriteTweet(id: tweet.id)
    }
    
    
    @IBAction func replyPressed(_ sender: Any) {
    }
}
