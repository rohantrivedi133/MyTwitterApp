//
//  User.swift
//  MyTweetBot
//
//  Created by Rohan Trivedi on 2/25/17.
//  Copyright © 2017 Rohan Trivedi. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var id: Int = 0
    var name: String
    var screenName: String
    var userImageURL: URL
    var bannerImageURL: URL?
    var tagLine: String
    var followingCount: Int = 0
    var followingString: String {
        return formatCount(count: followingCount)
    }
    var followersCount: Int = 0
    var followersString: String {
        return formatCount(count: followersCount)
    }
    var tweetsCount: Int = 0
    var tweetsString: String {
        return formatCount(count: tweetsCount)
    }

    
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        id = dictionary["id"] as! Int
        name = dictionary["name"] as! String
        screenName = dictionary["screen_name"] as! String
        userImageURL = URL(string: dictionary["profile_image_url_https"] as! String)!
        bannerImageURL = URL(string: dictionary["profile_banner_url"] as? String ?? "")
        tagLine = dictionary["description"] as! String
        followingCount = dictionary["friends_count"] as! Int
        followersCount = dictionary["followers_count"] as! Int
        tweetsCount = dictionary["statuses_count"] as! Int
    }
    
    static let userDidLogoutNotification = "UserDidLogout"
    
    static var _currentUser: User?
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let data = defaults.object(forKey: "currentUserData") as? Data
                if let data = data {
                    let dictionary = try! JSONSerialization.jsonObject(with: data, options: [])
                    _currentUser = User(dictionary: dictionary as! NSDictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
    
    func formatCount(count: Int) -> String {
        if count >= 1000000 {
            return "\(Double(count/100000).rounded()/10) M"
        } else if count >= 1000 {
            return "\(Double(count/100).rounded()/10) K"
        } else {
            return "\(count)"
        }
    }
}
