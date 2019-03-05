//
//  LogInViewController.swift
//  MelodyProject
//
//  Created by Tom on 12/8/18.
//  Copyright © 2018 Tom. All rights reserved.
//

import UIKit
import Firebase
class LogInViewController: UIViewController, UITextFieldDelegate {

    // MARK: UI elements
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginError: UILabel!
    @IBOutlet weak var loginButton: UIButton!

    
    // Workd place
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Listen to keyboard events (1 func in viewWillAppears)
        hideKeyboard() // hide keyboard when tap anywhere outside the textfield
        
        customNavigationBar()
        
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if passwordField.isSelected
        {
            keyboardEvents()
        }
    }
    
    // MARK: --------NAVIGATION BAR--------
    private func customNavigationBar()
    {
        navigationItem.title = "LOG IN"
        self.navigationController?.hidesBarsWhenKeyboardAppears = true
    }
    
    // MARK: --------KEYBOARD--------
    func keyboardEvents()
    {
        NotificationCenter.default.addObserver(self, selector: #selector (keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector (keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector (keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChange(notification: Notification)
    {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else
        {
            return
        }
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification
        {
            
            view.frame.origin.y = -1 * keyboardRect.height
        }
        else
        {
            view.frame.origin.y = 0
        }
    }
    
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector (dissmissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dissmissKeyboard()
    {
        view.endEditing(true)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: --------TEXTFIELD--------
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailField:
            emailField.resignFirstResponder()
            passwordField.becomeFirstResponder()
            break
        case passwordField:
            passwordField.resignFirstResponder()
            handleLogIn(loginButton)
        default:
            break
        }
        return true
    }
    
    // MARK: --------LOG IN BUTTON--------
    @IBAction func handleLogIn(_ sender: UIButton)
    {
        //Keyboard
        dissmissKeyboard()
        
        // Button title
        loginButton.setTitle("Logging in...", for: .normal)
        
        guard let email = emailField.text else {return}
        guard let password = passwordField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { (user: AuthDataResult?, error: Error?) in
            if user != nil
            {
                self.loginError.isHidden = true
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }
            else
            {
                self.loginButton.setTitle("Log In", for: .normal)
                self.loginError.isHidden = false
                self.loginError.text = error!.localizedDescription
            }
        }
    }
}
