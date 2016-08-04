//
//  Post.swift
//  socialApp
//
//  Created by Jonathan Bohrer on 8/4/16.
//  Copyright © 2016 Jonathan Bohrer. All rights reserved.
//

import Foundation
import Firebase

class Post {
    private var _caption: String!
    private var _imageUrl: String!
    private var _likes: Int!
    private var _postkey: String!
    private var _postRef: FIRDatabaseReference!
    
    var caption: String {
        return _caption
    }
    var imageUrl: String {
        return _imageUrl
    }
    var likes: Int {
        return _likes
    }
    var postKey: String {
        return _postkey
    }
    var postRef: FIRDatabaseReference {
        return _postRef
    }
    
    init(caption: String, imageUrl: String, likes: Int) {
        _caption = caption
        _imageUrl = imageUrl
        _likes = likes
    }
    
    init(postKey: String, postData: Dictionary<String,AnyObject>) {
        _postkey = postKey
        
        if let caption = postData["caption"] as? String {
            self._caption = caption
        }
        if let imageUrl = postData["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }
        if let likes = postData["likes"] as? Int {
            self._likes = Int(likes)
        }
        
        _postRef = DataService.instance.REF_POSTS.child(_postkey)
    }
    
    func adjustLikes(addLike: Bool) {
        
        if addLike {
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }

        _postRef.child("likes").setValue(_likes)
    }
    
}