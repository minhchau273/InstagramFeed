//
//  PhotosViewController.swift
//  InstagramFeed
//
//  Created by Dave Vo on 8/27/15.
//  Copyright (c) 2015 Chau Vo. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    
    var photos: NSMutableArray!
    
    var refreshControl: UIRefreshControl?
    
    var clientId: String!
    var url: NSURL!
    var request: NSURLRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clientId = "c66ada7e656a494c8d2d41890c1da3d1"
        
        url = NSURL(string: "https://api.instagram.com/v1/media/popular?client_id=\(clientId)")!
        
        request = NSURLRequest(URL: url)
        

        loadPhotos()
        
        tableView.dataSource = self
        tableView.delegate = self

        //Pull to refresh
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl!.addTarget(self, action: "loadPhotos", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl!)
        
        
    }
    
    func loadPhotos(){
        
        
        NSURLConnection.sendAsynchronousRequest(request!, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary
            self.photos = responseDictionary["data"] as! NSMutableArray!
            self.tableView.reloadData()
            
//            NSLog("response: \(self.photos)")
        }
        
        
        refreshControl?.endRefreshing()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let photos = photos {
            return photos.count
        } else {
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell
        
        let photo = photos![indexPath.section]
        
        let url = NSURL(string: photo.valueForKeyPath("images.low_resolution.url") as! String)!
        
        cell.photoView.setImageWithURL(url)
        
        
        // Infinite loading
        if indexPath.section == photos.count - 1 {
            NSURLConnection.sendAsynchronousRequest(request!, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                var responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary
                var newPhotos = responseDictionary["data"] as! NSMutableArray!
                
                for p in newPhotos {
                    self.photos.addObject(p);
                }
                
                
                
                self.tableView.reloadData()
                
                
                println("load new photos")
                
            }

        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let photo = photos![section]
        
        let username = photo.valueForKeyPath("user.username") as! String
        let avatarUrl = NSURL(string: photo.valueForKeyPath("user.profile_picture") as! String)!
        
        var headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        var profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
        profileView.layer.borderWidth = 1;
        
        profileView.setImageWithURL(avatarUrl)
        
        headerView.addSubview(profileView)
        
        // Add a UILabel for the username here
        var usernameLabel = UILabel(frame: CGRect(x: 50, y: 15, width: 150, height: 20))
        usernameLabel.textColor = UIColor(red: 24/255, green: 116/255, blue: 205/255, alpha: 1.0)
        usernameLabel.text = username
        
        headerView.addSubview(usernameLabel)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var vc = segue.destinationViewController as! PhotoDetailsViewController
        var indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
        
        
        let photo = photos![indexPath!.section]
        
        vc.selectedPhoto = photo as! NSDictionary
        
    }

   
}
