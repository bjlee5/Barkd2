//
//  MyPostCell.swift
//  Barkd1
//
//  Created by MacBook Air on 4/15/17.
//  Copyright © 2017 LionsEye. All rights reserved.
//

import UIKit
import Firebase

class MyPostCell: UITableViewCell {
    


    @IBOutlet weak var profilePic1: UIImageView!
    @IBOutlet weak var username1: UILabel!
    @IBOutlet weak var postPic1: UIImageView!
    @IBOutlet weak var postText1: UITextView!
    @IBOutlet weak var likesNumber1: UILabel!
    @IBOutlet weak var dateLabel1: UILabel!

    
    var post: Post!
    var likesRef: FIRDatabaseReference!
    var storageRef: FIRStorage {
        return FIRStorage.storage()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

    }
    
    // Load Current User //
    
    func loadUserInfo(){
        let userRef = DataService.ds.REF_BASE.child("users/\(FIRAuth.auth()!.currentUser!.uid)")
        userRef.observe(.value, with: { (snapshot) in
            
            let user = Users(snapshot: snapshot)
            self.username1.text = user.username
        })
        { (error) in
            print(error.localizedDescription)
        }
    }
    //
    
    func configureCell(post: Post, img: UIImage? = nil, proImg: UIImage? = nil) {
        
        username1.isHidden = true
        profilePic1.isHidden = true

        self.post = post
        self.likesRef = DataService.ds.REF_CURRENT_USERS.child("likes").child(post.postKey)
        self.postText1.text = post.caption
        self.likesNumber1.text = "\(post.likes)"
        self.dateLabel1.text = post.currentDate
        
        let userRef = DataService.ds.REF_BASE.child("users/\(FIRAuth.auth()!.currentUser!.uid)")
        userRef.observe(.value, with: { (snapshot) in
            self.username1.text = "\(post.postUser)"
        })
        
        if img != nil {
            self.postPic1.image = img
        } else {
            let ref = FIRStorage.storage().reference(forURL: post.imageURL)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("BRIAN: Unable to download image from Firebase")
                } else {
                    print("Image downloaded successfully")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postPic1.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageURL as NSString!)
                        }
                    }
                    
                    
                }
            })
            
            if proImg != nil {
                self.profilePic1.image = proImg
            } else {
                let ref = FIRStorage.storage().reference(forURL: post.profilePicURL)
                ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (proData, error) in
                    if error != nil {
                        print("BRIAN: Unable to download image from Firebase")
                    } else {
                        print("Image downloaded successfully")
                        if let proimgData = proData {
                            if let proImg = UIImage(data: proimgData) {
                                self.profilePic1.image = proImg
                                FeedVC.imageCache.setObject(proImg, forKey: post.profilePicURL as NSString!)
                            }
                        }
                        
                        
                    }
                })
                
            }
            
        }
    }
    
    @IBAction func deletePost(_ sender: Any) {
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("posts").child(uid!).removeValue(completionBlock: { (error, ref) in
            
            if error != nil {
                print("BRIAN: Your post has been deleted")
            }
            
        })
        
    }

    
}
