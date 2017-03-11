//
//  TweetCell.swift
//  MyTweetBot
//
//  Created by Rohan Trivedi on 2/27/17.
//  Copyright © 2017 Rohan Trivedi. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    var tweet: Tweet! {
        didSet {
            // Set up UI elements
            userImageView.setImageWith(tweet.author.userImageURL)
            nameLabel.text = tweet.author.name
            screenNameLabel.text = "@\(tweet.author.screenName)"
            timeStampLabel.text = tweet.timeStampText
            tweetTextLabel.text = tweet.text

            retweetCountLabel.text = "\(tweet.retweetCount)"
            favoriteCountLabel.text = "\(tweet.favoriteCount)"
            
            if tweet.retweeted == true {
                self.retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: UIControlState.normal)
            } else {
                self.retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon"), for: UIControlState.normal)
            }
            
            if tweet.favorited == true {
                self.favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: UIControlState.normal)
            } else {
                self.favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon"), for: UIControlState.normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = 5
        userImageView.clipsToBounds = true
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func unfavoriteTweet() {
        TwitterClient.sharedInstance?.unfavoriteTweet(success: { () in
            self.tweet.favoriteCount -= 1
            self.tweet.favorited = false
            self.favoriteCountLabel.text = "\(self.tweet.favoriteCount)"
            self.favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon"), for: UIControlState.normal)
        }, failure: { (error: Error) in
            print("error: \(error.localizedDescription)")
        }, tweetId: tweet.id)
    }
    @IBAction func onRetweetButton(_ sender: Any) {
        TwitterClient.sharedInstance?.retweetTweet(success: { () in
            self.tweet.retweetCount += 1
            self.tweet.retweeted = true
            self.retweetCountLabel.text = "\(self.tweet.retweetCount)"
            self.retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: UIControlState.normal)
        }, failure: { (error: Error) in
            print("error: \(error.localizedDescription)")
            // self.unretweetTweet()
        }, tweetId: tweet.id)
    }

    @IBAction func onFavoriteButton(_ sender: Any) {
        TwitterClient.sharedInstance?.favoriteTweet(success: { () in
            self.tweet.favoriteCount += 1
            self.tweet.favorited = true
            self.favoriteCountLabel.text = "\(self.tweet.favoriteCount)"
            self.favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: UIControlState.normal)
        }, failure: { (error: Error) in
            self.unfavoriteTweet()
        }, tweetId: tweet.id)
    }
    
    
}
