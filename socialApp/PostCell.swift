//
//  PostCell.swift
//  socialApp
//
//  Created by Jonathan Bohrer on 8/4/16.
//  Copyright © 2016 Jonathan Bohrer. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImg: circleView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likeImg: circleView!
    
    var post: Post!
    var likeref: FIRDatabaseReference!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.userInteractionEnabled = true
    }
    
    func configureCell(post: Post, image: UIImage? = nil) {
        self.post = post
        likeref = DataService.instance.REF_USER_CURRENT.child("likes").child(post.postKey)
        caption.text = post.caption
        likesLbl.text = String(post.likes)
        
        if image != nil {
            postImg.image = image
        } else {
            let imageUrl = post.imageUrl
            let ref = FIRStorage.storage().referenceForURL(imageUrl)
            ref.dataWithMaxSize(2 * 1024 * 1024, completion: { (data: NSData?, error: NSError?) in
                if error != nil {
                    print("JON: \(error.debugDescription)")
                } else {
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: imageUrl)
                        }
                    }
                }
            })
        }
        
        likeref.observeSingleEventOfType(.Value) { (snapshot: FIRDataSnapshot) in
            
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "empty-heart")
            } else {
                self.likeImg.image = UIImage(named: "filled-heart")
            }
        }
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        
        likeref.observeSingleEventOfType(.Value) { (snapshot: FIRDataSnapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(true)
                self.likeref.setValue(true)
            } else {
                self.likeImg.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(false)
                self.likeref.removeValue()
            }
        }
    }

}
