
//
//  ProfileViewController.swift
//  MyTweetBot
//
//  Created by Rohan Trivedi on 2/25/17.
//  Copyright © 2017 Rohan Trivedi. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userWrapperView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = user.name
        
    
        userWrapperView.layer.cornerRadius = 5
        userWrapperView.clipsToBounds = true
        
        userImageView.setImageWith(user.userImageURL)
        userImageView.layer.cornerRadius = 5
        userImageView.clipsToBounds = true
        
        nameLabel.text = user.name
        screenNameLabel.text = user.screenName
        descriptionLabel.text = user.tagLine
        tweetsCountLabel.text = user.tweetsString
        followingCountLabel.text = user.followingString
        followersCountLabel.text = user.followersString
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Compose segue
        let composeVC = segue.destination as! ComposeViewController
        composeVC.startingText = "@\(user.screenName)"
    }
}
