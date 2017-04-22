//
//  SlideOutViewController.swift
//  TwitterRedux
//
//  Created by Jonathan Wong on 4/17/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import UIKit

class SlideOutViewController: UIViewController {

    var leftViewController: UIViewController!
    var mainViewController: UIViewController!
    var overlap: CGFloat!
    var scrollView: UIScrollView!
    var firstLoad = true
    
    
    convenience init(leftViewController: UIViewController, mainViewController: UIViewController, overlap: CGFloat) {
        self.init()
        self.leftViewController = leftViewController
        self.mainViewController = mainViewController
        self.overlap = overlap
        
        setupScrollView()
        setupViewControllers()
        scrollView.contentOffset = CGPoint(x: leftViewController.view.bounds.width, y: 0)
        addShadowToView(destinationView: mainViewController.view)
    }
    
    func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        view.addSubview(scrollView)
        
        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|", options: [], metrics: nil, views: ["scrollView": scrollView])
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[scrollView]|", options: [], metrics: nil, views: ["scrollView": scrollView])
        NSLayoutConstraint.activate(constraints)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SlideOutViewController.viewTapped(_:)))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    func setupViewControllers() {
        addViewController(viewController: leftViewController)
        addViewController(viewController: mainViewController)
        
        let views: [String: Any] = ["left": leftViewController.view,
                     "main": mainViewController.view,
                     "outer": view]
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[left][main(==outer)]|", options: [.alignAllTop, .alignAllBottom], metrics: nil, views: views)
        NSLayoutConstraint(item: leftViewController.view,
                                                     attribute: .width, relatedBy: .equal, toItem: view,
                                                     attribute: .width, multiplier: 1.0, constant: -overlap).isActive = true
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[main(==outer)]|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(horizontalConstraints + verticalConstraints)
    }
    
    override func viewDidLayoutSubviews() {
        if firstLoad == true {
            closeSideBarAnimated(animated: false)
        }
        firstLoad = false
    }
    
    private func addViewController(viewController: UIViewController) {
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(viewController.view)
        addChildViewController(viewController)
        viewController.didMove(toParentViewController: self)
    }
    
    private func addShadowToView(destinationView: UIView) {
        destinationView.layer.shadowPath = UIBezierPath(rect: destinationView.bounds).cgPath
        destinationView.layer.shadowOffset = CGSize(width: 0, height: 0)
        destinationView.layer.shadowOpacity = 1.0
        destinationView.layer.shadowColor = UIColor.black.cgColor
    }
    
    func closeSideBarAnimated(animated: Bool) {
        scrollView.setContentOffset(CGPoint(x: leftViewController.view.bounds.width, y: 0), animated: animated)
    }
    
    func leftMenuIsOpen() -> Bool {
        return scrollView.contentOffset.x == 0
    }
    
    func openLeftMenuAnimated(animated: Bool) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: animated)
    }
    
    func toggleLeftMenuAnimated(animated: Bool) {
        if leftMenuIsOpen() {
            closeSideBarAnimated(animated: animated)
        } else {
            openLeftMenuAnimated(animated: animated)
        }
    }
    
    func viewTapped(_ sender: UITapGestureRecognizer) {
        closeSideBarAnimated(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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

}

//extension SlideOutViewController: HomeViewControllerDelegate {
//    func homeViewControllerDidTapMenuButton(viewController: HomeViewController) {
//        toggleLeftMenuAnimated(animated: true)
//    }
//}

extension SlideOutViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let tapLocation = touch.location(in: view)
        let tapOverlap = tapLocation.x >= view.bounds.width - overlap
        
        return tapOverlap && leftMenuIsOpen()
    }
}
