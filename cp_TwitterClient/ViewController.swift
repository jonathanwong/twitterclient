//
//  ViewController.swift
//  cp_TwitterClient
//
//  Created by Jonathan Wong on 4/10/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginPressed(_ sender: Any) {
        TwitterClient.sharedInstance.loginWithCompletion() {
            (user: User?, error: Error?) in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            } else {
                // handle login error
            }
        }
        
    }

}

