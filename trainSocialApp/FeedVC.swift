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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
    }

    @IBAction func signOutTapped(_ sender: UIButton) {
        
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("EN: ID removed from keychain")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
   
    

}
