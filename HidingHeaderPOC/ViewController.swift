//
//  ViewController.swift
//  HidingHeaderPOC
//
//  Created by Kevin Remigio on 7/16/17.
//  Copyright © 2017 Kevin Remigio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var headerView: UIView? = nil
    var tableView: UITableView? = nil
    
    
    let maxHeaderHeight: CGFloat = 450
    let minHeaderHeight: CGFloat = 44
    var previousScrollOffset: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.yellow.withAlphaComponent(0.2)
        
        setUpViews()
        
        tableView?.delegate = self
        tableView?.dataSource = self
        
        
    }

    func setUpViews() -> Void{
        let headerFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: 450)
        headerView = UIView(frame: headerFrame)
        headerView?.backgroundColor = UIColor.blue
        
        let tableFrame = CGRect(x: 0, y: 450, width: view.frame.width, height: view.frame.height - 450)
        tableView = UITableView(frame: tableFrame, style: .plain)
        
        
        view.addSubview(headerView!)
        view.addSubview(tableView!)
    
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel!.text = "Cell \(indexPath.row)"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if canAnimateHeader(scrollView) {
        
            let absoluteTop: CGFloat = 0
            let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
            
            let scrollDiff = scrollView.contentOffset.y - previousScrollOffset
            
            let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
            let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom
            
            var newHeight = tableView?.frame.height
            if isScrollingDown {
                newHeight = max(self.minHeaderHeight, (headerView?.frame.height)! - abs(scrollDiff))
                print("Down")
            } else if isScrollingUp {
                newHeight = min(self.maxHeaderHeight, (headerView?.frame.height)! + abs(scrollDiff))
                print("Up")
            }
            
            if newHeight != tableView?.frame.height {
                //self.headerHeightConstraint.constant = newHeight
                headerView?.frame.size.height = newHeight!
                tableView?.frame.origin.y = newHeight!
                tableView?.frame.size.height = view.frame.size.height - newHeight!
                
                print(newHeight!)
            }
            
            self.previousScrollOffset = scrollView.contentOffset.y
            
        }
        
    }
    
    func canAnimateHeader(_ scrollView: UIScrollView) -> Bool {
        // Calculate the size of the scrollView when header is collapsed
        let scrollViewMaxHeight = scrollView.frame.height + headerView!.frame.height - minHeaderHeight
        
        // Make sure that when header is collapsed, there is still room to scroll
        return scrollView.contentSize.height > scrollViewMaxHeight
    }
}






