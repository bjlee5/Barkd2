//
//  MyPosts.swift
//  Barkd1
//
//  Created by MacBook Air on 4/15/17.
//  Copyright © 2017 LionsEye. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class MyPostsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var posts = [Post]()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var profilePicLoaded = false
    var storageRef: FIRStorage {
        return FIRStorage.storage()
    }
    var following = [String]()
    /// Referencing the Storage DB then, current User
    let userRef = DataService.ds.REF_BASE.child("users/\(FIRAuth.auth()!.currentUser!.uid)")
    
    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        followingFriends()
        fetchPosts()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelectionDuringEditing = true
        
        
        // Dismiss Keyboard //
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
    } // End ViewDidLoad
    
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    

    
    /// Sort Feed of Posts by Current Date
    func sortDatesFor(this: Post, that: Post) -> Bool {
        return this.currentDate > that.currentDate
    }
    
    // Show Current User Feed //
    
    func followingFriends() {
        
        let ref = FIRDatabase.database().reference()
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            let users = snapshot.value as! [String: AnyObject]
            
            for (_, value) in users {
                if let uName = value["username"] as? String {
                    self.userRef.observe(.value, with: { (snapshot) in
                        
                        let myUser = Users(snapshot: snapshot)
                        
                        if uName == myUser.username {
                            if let followingUsers = value["following"] as? [String: String] {
                                for (_, user) in followingUsers {
                                    self.following.append(user)
                                    
                                }
                            }
                            
                            self.following.append((FIRAuth.auth()?.currentUser?.uid)!)
                            print("FEEDBRIAN: You are following these users \(self.following)")
                            
                        }
                    })
                }
            }
            
            self.fetchPosts()
        })
    }
    
    func fetchPosts() {
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            self.posts = []
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                print("LEE: \(snapshot)")
                for snap in snapshot {
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        if let postUser = postDict["uid"] as? String {
                            if postUser == FIRAuth.auth()?.currentUser?.uid {
                                
                                let key = snap.key
                                let post = Post(postKey: key, postData: postDict)
                                self.posts.append(post)
                                
                                
                            }
                        }
                    }
                }
                
                self.tableView.reloadData()
                self.posts.sort(by: self.sortDatesFor)
            }
        })
        
    }
    
    // User Feed //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TheCell", for: indexPath) as? MyPostCell {
            
            if let img = FeedVC.imageCache.object(forKey: post.imageURL as NSString!), let proImg = FeedVC.imageCache.object(forKey: post.profilePicURL as NSString!) {
                cell.configureCell(post: post, img: img, proImg: proImg)
            } else {
                cell.configureCell(post: post)
            }
            return cell
        } else {
            
            return MyPostCell()
            
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
//    func tableView(_ tableView: UITableView, commit: UITableViewCellEditingStyle, forRowAt: IndexPath) {
//        print(forRowAt.row)
//
//            let posted = self.posts[forRowAt.row].postKey
//            print("FUCK: \(posted)")
//            
//        FIRDatabase.database().reference().child(posted).removeValue { (error, ref) in
//            
//            if error != nil {
//                print("BRIAN: An error has occured as we were unable to process delete post")
//            }
//            
//           
//            self.posts.remove(at: forRowAt.row)
//            self.tableView.deleteRows(at: [forRowAt], with: .automatic)
//                print("BRIAN: The posts were deleted")
//            
//        }
//    }
    
    func tableView(_ tableView: UITableView, commit: UITableViewCellEditingStyle, forRowAt: IndexPath) {
        
        let posted = self.posts[forRowAt.row].postKey
        
        FIRDatabase.database().reference().child("posts").child(posted).removeValue { (error, ref) in
         
            if error != nil {
                print("BRIAN: Error - unable to process delete post.")
            }
            
            self.posts.remove(at: forRowAt.row)
            self.tableView.deleteRows(at: [forRowAt], with: .automatic)
            print("BRIAN: The posts were deleted")
            
        }
        
    }
    
    func currentPosts() {
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        let postsRef = FIRDatabase.database().reference().child("posts").child("S8OhMKKgm0WmS7GupEK7F7cZ7tl2")
        postsRef.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("CUNTZ: \(snap)")
                    let delete = snap.key
                    postsRef.child(delete).removeValue()
                    print("BRIAN: The post has been DELETED")
                }
            }
        })
    }
    
    @IBAction func backPress(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}


