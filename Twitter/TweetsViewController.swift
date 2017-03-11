//
//  TweetsViewController.swift
//  MyTweetBot
//
//  Created by Rohan Trivedi on 2/25/17.
//  Copyright © 2017 Rohan Trivedi. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error) in
            print("\(error.localizedDescription)");
        })

        NotificationCenter.default.addObserver(self, selector: #selector(reloadTimeline), name: NSNotification.Name(rawValue: "reload"), object: nil)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        
        tableView.insertSubview(refreshControl, at: 0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        } else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        cell.selectionStyle = .none
        cell.profileButton.tag = indexPath.row
        cell.replyButton.tag = indexPath.row

        
        return cell
    }
    
    func reloadTimeline(notification: Notification) {
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }
    func refreshControlAction (refreshControl: UIRefreshControl) {
        
        // Re-request hometimeline data
        TwitterClient.sharedInstance?.homeTimeline(success: { (moreTweets: [Tweet]) in
            for newTweet in moreTweets {
                self.tweets.insert(newTweet, at: 0)
                self.tableView.reloadData()
            }
        }, failure: { (error: Error) in
            print(error.localizedDescription)
            
        })
        self.tableView.reloadData()
        
        // Tell refreshControl to stop spinning
        refreshControl.endRefreshing()
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("preparing for segue: \(segue.identifier!)")
        if (segue.identifier == "TweetDetailsSegue") {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets[indexPath!.row]
            
            let tweetDetailVC = segue.destination as! TweetDetailViewController
            tweetDetailVC.tweet = tweet
            
        } else if (segue.identifier == "ProfileSegue") {
            let indexPathRow = (sender as! UIButton).tag
            let tweet = tweets[indexPathRow];
            
            let profileVC = segue.destination as! ProfileViewController
            profileVC.user = tweet.author
            
        } else if (segue.identifier == "ReplySegue") {
            let indexPathRow = (sender as! UIButton).tag
            let tweet = tweets[indexPathRow];
            
            let composeVC = segue.destination as! ComposeViewController
            composeVC.startingText = "@\(tweet.author.screenName)"
        }
    }
}
