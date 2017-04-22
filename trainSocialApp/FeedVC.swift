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

class FeedVC: UIViewController,UITableViewDelegate,UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageAdd: UIImageView!
    @IBOutlet weak var captionField: UITextField!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var imgSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshots) in
            
            self.posts = []
            
            if let snapshot = snapshots.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    
                    if let postDict = snap.value as? Dictionary<String,AnyObject> {
                        
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        //self.posts.append(post)
                        self.posts.insert(post, at: 0)
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
            
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, img: img)
            } else {
                cell.configureCell(post: post)
            }
            return cell
        } else {
            return PostCell()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            imageAdd.image = image
            imgSelected = true
        }
            
        imagePicker.dismiss(animated: true, completion: nil)
    }
    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
        
    }
    @IBAction func postBtnTapped(_ sender: Any) {
        
        guard let caption = captionField.text, caption != "" else {
            print("EN: Caption must be enterd")
            return
        }
        
        guard let img = imageAdd.image, imgSelected == true else {
            print("EN: An image must be selected")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            let imgUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataService.ds.REF_POST_IMAGES.child(imgUid).put(imgData, metadata: metadata, completion: { (metadata, error) in
                if error != nil {
                    print("EN: Unable to upload image to Firebase storage")
                } else {
                    print("EN: Successfully upload image to Firebase storage")
                    
                    if let url = metadata?.downloadURL()?.absoluteString {
                        self.postToFirebase(imgUrl: url)
                    }

                }
            })
            
        }
    }
    
    func postToFirebase (imgUrl: String) {
        
        let post: Dictionary<String, AnyObject> = [
        "caption": captionField.text! as AnyObject,
        "imageUrl": imgUrl as AnyObject,
        "likes": 0 as AnyObject
        ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        captionField.text = ""
        imgSelected = false
        imageAdd.image = UIImage(named: "add-image")
        
        tableView.reloadData()
        
    }
    
    
    @IBAction func signOutTapped(_ sender: UIButton) {
        
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("EN: ID removed from keychain")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
   
    

}
