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
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let blueColor = UIColor(red: 74/255, green: 163/255, blue: 221/255, alpha: 1.0)
        self.loginButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        self.loginButton.backgroundColor = blueColor
        
        self.signUpButton.setTitleColor(blueColor, for: UIControl.State.normal)
    }


    @IBAction func onLoginTap(_ sender: Any) {
        
        let userName = userNameTextField.text
        let password = passwordTextField.text
        
        func validateInputValue(inputValue: String?, errorMessage: String, completion: @escaping (Bool) -> Void) {
            
            if((inputValue ?? "").isEmpty) {
                
                let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
                
                let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    _ in
                    completion(false)
                }
                
                alert.addAction(alertAction)
                
                self.present(alert, animated: true, completion: nil)
                
            }else{
                completion(true)
            }
        }
        
        func initiateLoginRequest() {

            NetworkService.login(userName: userName!, password: password!) {
                isSuccessful, errorMessage in
                if(isSuccessful){
                    print("successful login")
                }else{
                    let alert = UIAlertController(title: "Login Error", message: errorMessage ?? "Something went wrong!", preferredStyle: UIAlertController.Style.alert)
                    
                    let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                    alert.addAction(alertAction)
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        validateInputValue(inputValue: userName, errorMessage: "Username is required") {
            result in
            if(!result) {
                return
            }
            
            validateInputValue(inputValue: password, errorMessage: "Password is required") {
                result in
                if(!result) {
                    return
                }
                
                initiateLoginRequest()
            }
        }
        

        

        
    }
    
    @IBAction func onSignUpTap(_ sender: Any) {
        
        print("Sign up tapped")
    }
    
}

