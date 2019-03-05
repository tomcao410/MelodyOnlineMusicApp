//
//  ViewController.swift
//  MelodyProject
//
//  Created by Tom on 12/7/18.
//  Copyright © 2018 Tom. All rights reserved.
//

import UIKit
import Firebase


class MenuViewController: UIViewController {

    
    // MARK: Work place
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customNavigationBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
   
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser != nil
        {
            self.performSegue(withIdentifier: "homeSegue", sender: self)
            // Disable the first Navigation Controller
            navigationItem.leftBarButtonItem?.isEnabled = false
            navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
    
    // MARK: Custom Nav Bar
    func customNavigationBar()
    {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }

}

