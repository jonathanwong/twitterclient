//
//  ProfileViewController.swift
//  cp_TwitterClient
//
//  Created by Jonathan Wong on 4/21/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var headerView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var countTweetsLabel: UILabel!
    @IBOutlet weak var countFollowingLabel: UILabel!
    @IBOutlet weak var countFollowersLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var user: User!
    var screenname: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if user != nil {
            TwitterClient.sharedInstance.users(userId: user.id!, completion: {
                (user: User!, error) in
                
                self.updateUserProfile(user: user)
                self.headerView.setImageWith(URL(string: user.backgroundImageUrl!)!)
                self.usernameLabel.text = user.name
                self.screennameLabel.text = "@\(user.screenname!)"
                self.countTweetsLabel.text = "\(user.countTweets!)"
                self.countFollowingLabel.text = "\(user.countFollowing!)"
                self.countFollowersLabel.text = "\(user.countFollowers!)"
                self.profileImageView.setImageWith(URL(string: user.profileImageUrl!)!)
            })
        } else if screenname != nil {
            TwitterClient.sharedInstance.users(screenname: screenname!, completion: {
                (user: User!, error) in
                
                self.updateUserProfile(user: user)
                self.headerView.setImageWith(URL(string: user.backgroundImageUrl!)!)
                self.usernameLabel.text = user.name
                self.screennameLabel.text = "@\(user.screenname!)"
                self.countTweetsLabel.text = "\(user.countTweets!)"
                self.countFollowingLabel.text = "\(user.countFollowing!)"
                self.countFollowersLabel.text = "\(user.countFollowers!)"
                self.profileImageView.setImageWith(URL(string: user.profileImageUrl!)!)
            })
        }
        
        
        
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

    func updateUserProfile(user: User) {
        
    }
}
