//
//  FeedVC.swift
//  socialApp
//
//  Created by Jonathan Bohrer on 8/3/16.
//  Copyright © 2016 Jonathan Bohrer. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var captionField: betterField!
    @IBOutlet weak var imageAdd: circleView!
    
    var posts = [Post]()
    var imagePicker = UIImagePickerController()
    static var imageCache: NSCache = NSCache()
    var imageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        DataService.instance.REF_POSTS.observeEventType(.Value) { (snapshot: FIRDataSnapshot) in
            if let snaps = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.posts = []
                for snap in snaps {
                    if let postDict = snap.value as? Dictionary<String,AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell {
            
            if let img = FeedVC.imageCache.objectForKey(post.imageUrl) as? UIImage {
                cell.configureCell(post, image: img)
            } else {
                cell.configureCell(post)
            }
            
            return cell
        } else {
            return PostCell()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdd.image = image
            imageSelected = true
            imageAdd.clipsToBounds = true
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    @IBAction func postBtnPressed(sender: AnyObject) {
        
        guard let caption = captionField.text where caption != "" else {
            return
        }
        guard let img = imageAdd.image where imageSelected else {
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            let imgId = NSUUID().UUIDString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            DataService.instance.REF_POST_IMAGES.child(imgId).putData(imgData, metadata: metadata, completion: { (metadata: FIRStorageMetadata?, error: NSError?) in
                
                if error != nil {
                    print("JON: Unable to upload image")
                } else {
                    if let downloadUrl = metadata?.downloadURL()?.absoluteString {
                        self.postToFirebase(downloadUrl)
                    }
                }
            })
        }
    }
    
    func postToFirebase(imgUrl: String) {
        let post: Dictionary<String,AnyObject> = [
            "caption": captionField.text!,
            "imageUrl": imgUrl,
            "likes": 0
        ]
        
        let firebasePost = DataService.instance.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        captionField.text = ""
        imageSelected = false
        imageAdd.image = UIImage(named: "add-image")
        imageAdd.clipsToBounds = false
        
        tableView.reloadData()
    }
    
    @IBAction func addImgTapped(sender: AnyObject) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func signOutPressed(sender: AnyObject) {
        
        KeychainWrapper.removeObjectForKey(KEY_UID)
        try! FIRAuth.auth()?.signOut()
        performSegueWithIdentifier("goToSignIn", sender: nil)
    }

}
