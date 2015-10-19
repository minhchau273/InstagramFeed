//
//  PhotoDetailsViewController.swift
//  InstagramFeed
//
//  Created by Dave Vo on 8/27/15.
//  Copyright (c) 2015 Chau Vo. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var comments: NSArray!
    
    
    var selectedPhoto: NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        comments = selectedPhoto.valueForKeyPath("comments.data") as! NSArray

        self.tableView.reloadData()
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count + 1
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            var cell = tableView.dequeueReusableCellWithIdentifier("PhotoDetailCell", forIndexPath: indexPath) as! PhotoDetailCell
            
            let url = NSURL(string: selectedPhoto.valueForKeyPath("images.low_resolution.url") as! String)!
            cell.detailPhoto.setImageWithURL(url)
            
            return cell
        } else {
            var cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as! UITableViewCell
            let comment = comments![indexPath.row - 1]
            println("HERE IS COMMENT: \(comment)")
            
            cell.textLabel!.text = comments![indexPath.row - 1].valueForKeyPath("text") as? String
            
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 320
        } else {
            return 50
        }
    }
    

    

}
