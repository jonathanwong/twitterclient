//
//  CreateTweetViewController.swift
//  cp_TwitterClient
//
//  Created by Jonathan Wong on 4/14/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import UIKit

protocol CreateTweetViewControllerDelegate: class {
    func createTweetViewControllerDelegateDidTweet(tweet: Tweet)
}

class CreateTweetViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var characterLimitLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var sendTweetButton: UIBarButtonItem!
    
    var user: User!
    let tweetMaxLength = 140
    
    weak var createTweetViewControllerDelegate: CreateTweetViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        characterLimitLabel.textColor = UIColor.flatGray
        avatarImageView.setImageWith(URL(string: user.profileImageUrl!)!)
        usernameLabel.text = user.name
        screennameLabel.text = user.screenname
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

    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func sendTweet(_ sender: Any) {
        if tweetTextView.text.characters.count > 0 {
            TwitterClient.sharedInstance.sendTweet(text: tweetTextView.text!, completion: {
                (tweet: Tweet!, error: Error?) in
                self.createTweetViewControllerDelegate?.createTweetViewControllerDelegateDidTweet(tweet: tweet)
            })
            
            tweetTextView.resignFirstResponder()
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    func canSendTweet() -> Bool {
        return tweetTextView.text.characters.count > 0
    }
}

extension CreateTweetViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if canSendTweet() {
            sendTweetButton.isEnabled = true
        } else {
            sendTweetButton.isEnabled = false
        }
        let currentString = textView.text as NSString?
        if let currentString = currentString {
            characterLimitLabel.text = "\(tweetMaxLength - currentString.length)"
        }
        let newString =
            currentString?.replacingCharacters(in: range, with: text)
        
        let centerY = self.characterLimitLabel.center.y
        
        UIView.animate(withDuration: 0.1, animations: {
            self.characterLimitLabel.center.y += 2
        }, completion: {
            _ in
            self.characterLimitLabel.center.y = centerY
        })
        
        return (newString?.characters.count)! <= tweetMaxLength
    }
}
