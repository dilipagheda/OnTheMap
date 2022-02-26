//
//  ViewController.swift
//  OnTheMap
//
//  Created by Dilip Agheda on 26/2/22.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loginButton.titleLabel?.textColor = UIColor.white
        self.loginButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        self.loginButton.backgroundColor = UIColor(red: 74/255, green: 163/255, blue: 221/255, alpha: 1.0)
    }


}

