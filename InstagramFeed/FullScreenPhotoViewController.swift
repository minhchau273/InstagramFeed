//
//  FullScreenPhotoViewController.swift
//  InstagramFeed
//
//  Created by Dave Vo on 8/28/15.
//  Copyright (c) 2015 Chau Vo. All rights reserved.
//

import UIKit

class FullScreenPhotoViewController: UIViewController {

    var scrollView: UIScrollView!
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView = UIImageView()
        let url = NSURL(string: "https://scontent.cdninstagram.com/hphotos-xfa1/t51.2885-15/s640x640/sh0.08/e35/11821904_997338603652141_1447319368_n.jpg")!
        imageView.setImageWithURL(url)
        
        scrollView = UIScrollView(frame: view.bounds)
//        scrollView.backgroundColor = UIColor.blackColor()
        scrollView.contentSize = imageView.bounds.size
        scrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        
        scrollView.addSubview(imageView)
        view.addSubview(scrollView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
