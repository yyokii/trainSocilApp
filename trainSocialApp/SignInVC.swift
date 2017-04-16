//
//  SignInVC.swift
//  trainSocialApp
//
//  Created by 東原与生 on 2017/04/15.
//  Copyright © 2017年 yoki. All rights reserved.
//

import UIKit
import Firebase

class SignInVC: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pasField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func signinTapped(_ sender: UIButton) {
        
        if let mail = emailField.text, let pwd = pasField.text {
            
            FIRAuth.auth()?.signIn(withEmail: mail, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("EN: Email user authenticated with Firebase")
                } else {
                    
                    FIRAuth.auth()?.createUser(withEmail: mail, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("EN: error creatUser \(error)")
                        } else {
                            print("EN: Successfully authenticated with Firebase")
                        }
                    })
                }
                
                
            })
        }
    }


}

