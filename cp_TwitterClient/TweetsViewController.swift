//
//  TweetsViewController.swift
//  cp_TwitterClient
//
//  Created by Jonathan Wong on 4/13/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {

    @IBOutlet weak var tweetsTableView: UITableView!
    
    var tweets: [Tweet]?
    var selectedTweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        tweetsTableView.estimatedRowHeight = 120
        

        TwitterClient.sharedInstance.homeTimelineWithParams(params: nil, completion: {
            (tweets, error) -> () in
            self.tweets = tweets
            self.tweetsTableView.reloadData()
        })
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TweetsViewController.getTweets(_:)), for: .valueChanged)
        tweetsTableView.insertSubview(refreshControl, at: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createTweetSegue" {
            let destination = segue.destination as! UINavigationController
            let vc = destination.topViewController as! CreateTweetViewController
            vc.user = User.currentUser
            vc.createTweetViewControllerDelegate = self
            
        } else if segue.identifier == "detailTweetSegue" {
            let destination = segue.destination as! TweetDetailViewController
            if selectedTweet != nil {
                destination.tweet = selectedTweet
            }
        }
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        User.currentUser?.logout()
    }
    
    
    @IBAction func addTweetPressed(_ sender: Any) {
        performSegue(withIdentifier: "createTweetSegue", sender: self)
    }
    
    func getTweets(_ sender: UIRefreshControl) {
        TwitterClient.sharedInstance.homeTimelineWithParams(params: nil, completion: {
            (tweets, error) -> () in
            self.tweets = tweets
            self.tweetsTableView.reloadData()
            sender.endRefreshing()
        })
    }
}

extension TweetsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell", for: indexPath) as! TweetTableViewCell
        
        if let tweets = tweets {
            cell.avatarImageView.image = nil
            let tweet = tweets[indexPath.row]
            cell.tweet = tweet
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if var tweets = tweets {
                let tweet = tweets[indexPath.row]
                TwitterClient.sharedInstance.deleteTweet(id: tweet.id)
                tweets.remove(at: indexPath.row)
                tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
                
//                TwitterClient.sharedInstance.homeTimelineWithParams(params: nil, completion: {
//                    (tweets, error) -> () in
//                    self.tweets = tweets
//                    self.tweetsTableView.reloadData()
//                })
            }
        }
    }
}

extension TweetsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tweets = tweets {
            selectedTweet = tweets[indexPath.row]
            performSegue(withIdentifier: "detailTweetSegue", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TweetsViewController: CreateTweetViewControllerDelegate {
    func createTweetViewControllerDelegateDidTweet(tweet: Tweet) {
        if var tweets = tweets {
            tweets.insert(tweet, at: 0)
            DispatchQueue.main.async {
                self.tweetsTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            }
            
        }
    }
}
