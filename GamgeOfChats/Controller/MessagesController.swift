//
//  ViewController.swift
//  GamgeOfChats
//
//  Created by Veaceslav Chirita on 10/9/20.
//  Copyright © 2020 Veaceslav Chirita. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class MessagesController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        let image = UIImage(named: "create")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        
        checkIfUserIsLoggedIn()
    }
    
    @objc func handleNewMessage() {
        let newMessageController = NewMessageTableViewController()
        let navController = UINavigationController(rootViewController: newMessageController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
    
    private func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value) { [weak self] (snapshot) in
                guard let self = self else { return }
                print(snapshot)
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.navigationItem.title = dictionary["name"] as! String
                }
                
                
            }
        }
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        
        let loginController = LoginController()
        loginController.modalPresentationStyle = .fullScreen
        present(loginController, animated: true, completion: nil)
    }


}

