/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import FBSDKCoreKit

class ViewController: UIViewController {

    @IBAction func facebookLoginClicked(sender: AnyObject) {
        // Set up permissions required
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
//        if let _ = PFUser.currentUser()?.username {
//            if let isDriver = PFUser.currentUser()?["isDriver"] as? Bool{
//                print("User already signed up for Uber")
//                if isDriver == true {
//                    self.performSegueWithIdentifier("showDriverView", sender: self)
//                } else {
//                    self.performSegueWithIdentifier("showRiderView", sender: self)
//                }
//            } else {
//                self.performSegueWithIdentifier("showSignUpView", sender: self)
//            }
//        }
    }
}
