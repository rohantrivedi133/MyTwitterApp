//
//  ComposeViewController.swift
//  MyTweetBot
//
//  Created by Rohan Trivedi on 2/25/17.
//  Copyright © 2017 Rohan Trivedi. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextField: UITextView!
    
    var startingText: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        if startingText != nil {
            tweetTextField.text = "\(startingText!) "
        }
        tweetTextField.becomeFirstResponder()
        tweetTextField.delegate = self
        
        userImageView.setImageWith((User.currentUser?.userImageURL)!)
        userImageView.layer.cornerRadius = 5
        userImageView.clipsToBounds = true
        
        nameLabel.text = User.currentUser?.name
        screenNameLabel.text = "@\(User.currentUser!.screenName)"
        
        if tweetTextField.text.characters.count < 0
        {
            characterCountLabel.textColor = UIColor.red
            characterCountLabel.text = "\(140 - tweetTextField.text.characters.count)"
        }
        else
        {
            characterCountLabel.text = "\(140 - tweetTextField.text.characters.count)"
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTweetButton(_ sender: Any) {
        TwitterClient.sharedInstance?.postTweet(success: { () in
            self.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
        }, failure: { (error: Error) in
            print("error: \(error.localizedDescription)")
        }, status: tweetTextField.text!)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if tweetTextField.text.characters.count < 0
        {
            characterCountLabel.textColor = UIColor.red
            characterCountLabel.text = "\(140 - tweetTextField.text.characters.count)"
        }
        else
        {
            characterCountLabel.text = "\(140 - tweetTextField.text.characters.count)"
        }
        
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
