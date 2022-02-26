//
//  ViewController.swift
//  OnTheMap
//
//  Created by Dilip Agheda on 26/2/22.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let blueColor = UIColor(red: 74/255, green: 163/255, blue: 221/255, alpha: 1.0)
        self.loginButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        self.loginButton.backgroundColor = blueColor
        
        self.signUpButton.setTitleColor(blueColor, for: UIControl.State.normal)
    }


    @IBAction func onLoginTap(_ sender: Any) {
        
        print("Login tapped")
    }
    
    @IBAction func onSignUpTap(_ sender: Any) {
        
        print("Sign up tapped")
    }
    
}

