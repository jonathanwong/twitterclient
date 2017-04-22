//
//  MentionsViewController.swift
//  cp_TwitterClient
//
//  Created by Jonathan Wong on 4/21/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(MentionsViewController.logoutPressed(_:)))
        self.navigationItem.title = "Mentions"
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

    func logoutPressed(_ sender: UIBarButtonItem) {
        User.currentUser?.logout()
    }
}
