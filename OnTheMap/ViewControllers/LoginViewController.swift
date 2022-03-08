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
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.loginButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        self.updateLoginButtonUI(isEnabled: true)
        
        self.signUpButton.setTitleColor(Colors.blue, for: UIControl.State.normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        userNameTextField.text = ""
        passwordTextField.text = ""
        userNameTextField.becomeFirstResponder()
    }
    
    private func updateLoginButtonUI(isEnabled: Bool) {
        
        self.loginButton.isEnabled = isEnabled
        
        if(isEnabled) {
            self.loginButton.backgroundColor = Colors.blue
            
        }else {
            self.loginButton.backgroundColor = UIColor.lightGray
        }
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
            
            func updateUI(isLoginInProgress: Bool) {
                
                if(isLoginInProgress) {
                    self.updateLoginButtonUI(isEnabled: false)
                    activityView.startAnimating()
                }else{
                    self.updateLoginButtonUI(isEnabled: true)
                    activityView.stopAnimating()
                }
            }
            
            updateUI(isLoginInProgress: true)
            
            NetworkService.login(userName: userName!, password: password!) {
                isSuccessful, errorMessage in
                if(isSuccessful){
                    
                    NetworkService.getUserData() {
                        (isSuccessful) in
                        if(isSuccessful) {
                            updateUI(isLoginInProgress: false)
                            
                            self.performSegue(withIdentifier: "showLandingView", sender: nil)
                        }else{
                            Alerts.setParentView(parentView: self)
                                .showError(errorMessage: "Error while fetching user data")
                        }
                    }

                }else{
                    Alerts.setParentView(parentView: self)
                        .showError(errorMessage: errorMessage ?? "Sorry! Something went wrong!")
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
        
        let url = URL(string: "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com")!
        let app = UIApplication.shared
        app.open(url)
    }
    
}

