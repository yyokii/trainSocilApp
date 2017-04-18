//
//  FeedVC.swift
//  trainSocialApp
//
//  Created by 東原与生 on 2017/04/16.
//  Copyright © 2017年 yoki. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshots) in
            
            if let snapshot = snapshots.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    
                    if let postDict = snap.value as? Dictionary<String,AnyObject> {
                        
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                    
                }
            }
            self.tableView.reloadData()
        
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            cell.configureCell(post: post)
            return cell
        } else {
            return PostCell()
        }
    
    }

    @IBAction func signOutTapped(_ sender: UIButton) {
        
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("EN: ID removed from keychain")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
   
    

}
