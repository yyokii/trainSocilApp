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

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func signOutTapped(_ sender: UIButton) {
        
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("EN: ID removed from keychain")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
   
    

}
