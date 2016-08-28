//
//  ViewController.swift
//  Lowkl
//
//  Created by Jorge Luis Perales on 27/08/16.
//  Copyright © 2016 Jorge Luis Perales. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    let loginButton = FBSDKLoginButton()
    var userDatabaseRef: FIRDatabaseReference!
    
    @IBOutlet weak var aivLoadingSpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.loginButton.hidden = true
        
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if user != nil {
                // User is signed in. Move user to homescreen
                let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                let homeViewController: UIViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("HomeView")
                
                self.presentViewController(homeViewController, animated: true, completion: nil)
                
            } else {
                // No user is signed in. Move user to login screen
                // Optional: Place the button in the center of your view.
                self.loginButton.center = self.view.center
                self.loginButton.readPermissions = ["public_profile", "email", "user_friends"]
                self.loginButton.delegate = self
                
                self.view!.addSubview(self.loginButton)
                
                self.loginButton.hidden = false
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User did log in to FB")
        
        self.loginButton.hidden = true
        
        aivLoadingSpinner.startAnimating()
        
        if (error != nil) {
            //Handle errors
            print(error)
            self.loginButton.hidden = false
            aivLoadingSpinner.stopAnimating()
        } else if (result.isCancelled) {
            //Handle cancel event
            self.loginButton.hidden = false
            aivLoadingSpinner.stopAnimating()
        } else {
            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
            
            userDatabaseRef = FIRDatabase.database().reference().child("users")
            
            FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                print("User did log in to FireBase")
                
                self.userDatabaseRef.child(user!.uid + "/guide").setValue(false)
                self.userDatabaseRef.child(user!.uid + "/takenTours").setValue([1,2])
                self.userDatabaseRef.child(user!.uid + "/upcomingTours").setValue([2,3])
                self.userDatabaseRef.child(user!.uid + "/rating").setValue(5)
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User did log out")
    }
}
