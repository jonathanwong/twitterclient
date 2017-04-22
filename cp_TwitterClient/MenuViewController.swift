//
//  MenuViewController.swift
//  cp_TwitterClient
//
//  Created by Jonathan Wong on 4/19/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import UIKit

protocol MenuViewControllerDelegate: class {
    func menuViewController(_ controller: MenuViewController, didSelectRow row: Int)
}

class MenuViewController: UIViewController {

    @IBOutlet weak var menuTableView: UITableView!
    
    public let menuSource = ["Profile", "Timeline", "Mentions", "Account"]
    
    weak var delegate: MenuViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuTableView.rowHeight = 100
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProfileViewController" {
            let destination = segue.destination as! ProfileViewController
            
        }
        
    }
 

}

extension MenuViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
        cell.menuLabel.text = menuSource[indexPath.row]
        
        return cell
    }
}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.menuViewController(self, didSelectRow: indexPath.row)
    }
}
