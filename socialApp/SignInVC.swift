//
//  ViewController.swift
//  socialApp
//
//  Created by Jonathan Bohrer on 8/3/16.
//  Copyright © 2016 Jonathan Bohrer. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {

    @IBOutlet weak var emailField: betterField!
    @IBOutlet weak var passwordField: betterField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        if let _ = KeychainWrapper.stringForKey(KEY_UID) {
            performSegueWithIdentifier("goToFeed", sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func fbBtnPressed(sender: AnyObject) {
        
        let fbLogin = FBSDKLoginManager()
        fbLogin.logInWithReadPermissions(["email"], fromViewController: self) { (result: FBSDKLoginManagerLoginResult!, error: NSError!) in
            if error != nil {
                print("JON: Unable to authenticate with Facebook - \(error.debugDescription)")
            } else if result.isCancelled {
                print("JON: User cancelled")
            } else {
                print("JON: Authenticated with FB")
                let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
                self.firebaseAuthenticate(credential)
            }
        }
    }
    
    func firebaseAuthenticate(credential: FIRAuthCredential) {
        
        FIRAuth.auth()?.signInWithCredential(credential, completion: { (user: FIRUser?, error: NSError?) in
            
            if error != nil {
                print("JON: Unable to authenticate with Firebase - \(error.debugDescription)")
            } else {
                print("JON: Authenticated with Firebase")
                let userData = ["provider": credential.provider]
                self.completeSignIn((user?.uid)!, userData: userData)
            }
        })
    }
    
    @IBAction func signInTapped(sender: AnyObject) {
        
        if let email = emailField.text, pass = passwordField.text {
            FIRAuth.auth()?.signInWithEmail(email, password: pass, completion: { (user: FIRUser?, error: NSError?) in
                
                if error == nil {
                    print("JON: Email authenticated")
                    let userData = ["provider": user!.providerID]
                    self.completeSignIn((user?.uid)!,userData: userData)
                } else {
                    FIRAuth.auth()?.createUserWithEmail(email, password: pass, completion: { (user, err) in
                        if err != nil {
                            print("JON: Unable to create user - \(err.debugDescription)")
                        } else {
                            print("JON: Created user")
                            let userData = ["provider": user!.providerID]
                            self.completeSignIn((user?.uid)!,userData: userData)
                        }
                    })
                }
            })
            
        }
        
    }
    
    func completeSignIn(id: String, userData: Dictionary<String,String>) {
        DataService.instance.createFirDBUser(id, userData: userData)
        KeychainWrapper.setString(id, forKey: KEY_UID)
        performSegueWithIdentifier("goToFeed", sender: nil)
    }
    
}

