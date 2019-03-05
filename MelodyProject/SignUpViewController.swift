//
//  SignUpViewController.swift
//  MelodyProject
//
//  Created by Tom on 12/7/18.
//  Copyright © 2018 Tom. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {

    // MARK: UI elements
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPassWordField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var confirmError: UILabel!
    
    
    // MARK: Work place
    override func viewDidLoad() {
        super.viewDidLoad()

        customNavigationBar()
        
        // Listen to keyboard events (1 func in viewWillAppears)
        hideKeyboard() // hide keyboard when tap anywhere outside the textfield
        
        // TextField delegate
        emailField.delegate = self
        nameField.delegate = self
        passwordField.delegate = self
        confirmPassWordField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if confirmPassWordField.isSelected
        {
            keyboardEvents()
        }
        
    }
    
    // MARK: --------NAVIGATION BAR--------
    private func customNavigationBar()
    {
        navigationItem.title = "CREATE ACCOUNT"
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
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector (dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
        self.navigationController?.isNavigationBarHidden = false
    }
    // MARK: --------TEXTFIELD--------
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch  textField {
        case emailField:
            emailField.resignFirstResponder()
            nameField.becomeFirstResponder()
            break
        case nameField:
            nameField.resignFirstResponder()
            passwordField.becomeFirstResponder()
            break
        case passwordField:
            passwordField.resignFirstResponder()
            confirmPassWordField.becomeFirstResponder()
            break
        case confirmPassWordField:
            createHandle(createButton)
            break
        default:
            break
        }
        return true
    }
    
    // MARK: --------CREATE BUTTON--------
    @IBAction func createHandle(_ sender: UIButton)
    {
        dismissKeyboard()
        
        guard let email = emailField.text else {return}
        guard let password = passwordField.text else {return}
        guard let username = nameField.text else {return}
        guard  let confirmPW = confirmPassWordField.text else {return}
        
        if confirmPW == password
        {
            confirmError.isHidden = true
            createButton.setTitle("Creating...", for: .normal)
            
            Auth.auth().createUser(withEmail: email, password: password)
            { (user: AuthDataResult?, error: Error?) in
                if user != nil && error == nil
                {
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = username
                    self.navigationController?.popViewController(animated: false  )
                    self.dismiss(animated: false, completion: nil)
                }
                else
                {
                    self.createButton.setTitle("Create", for: .normal)
                    self.confirmError.isHidden = false
                    self.confirmError.text = error!.localizedDescription
                }
            }
        }
        else
        {
            confirmError.isHidden = false
            confirmError.text = "Your repeat password is incorrect!"
        }
    }
}
