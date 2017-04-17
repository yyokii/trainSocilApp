//
//  SignInVC.swift
//  trainSocialApp
//
//  Created by 東原与生 on 2017/04/15.
//  Copyright © 2017年 yoki. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pasField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }

    @IBAction func signinTapped(_ sender: UIButton) {
        
        if let mail = emailField.text, let pwd = pasField.text {
            
            FIRAuth.auth()?.signIn(withEmail: mail, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("EN: Email user authenticated with Firebase")
                    
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    
                    FIRAuth.auth()?.createUser(withEmail: mail, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("EN: error creatUser \(error)")
                        } else {
                            print("EN: Successfully authenticated with Firebase")
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                        }
                    })
                }
                
                
            })
        }
    }
    
    func completeSignIn (id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("EN: saved keychain")
        performSegue(withIdentifier: "goToFeed", sender: nil)

    }


}

