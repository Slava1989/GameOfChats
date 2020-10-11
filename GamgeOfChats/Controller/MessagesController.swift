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
            fetchUserAndSetupNavBarTitle()
        }
    }
    
    func fetchUserAndSetupNavBarTitle() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { [weak self] (snapshot) in
            guard let self = self else { return }
            print(snapshot)
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User(
                    name: dictionary["name"] as! String,
                    email: dictionary["email"] as! String,
                    profileImageUrl: dictionary["profileImageUrl"] as? String
                    )
                self.setupNavbarWithUser(user: user)
            }
        }
    }
    
    func setupNavbarWithUser(user: User) {
//        self.navigationItem.title = user.name
        let titleView = UIButton()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        titleView.backgroundColor = .red
        
        let profileImageView = UIImageView()
        profileImageView.loadImageUsingCacheWithUrlString(urlString: user.profileImageUrl)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        titleView.addSubview(profileImageView)
        
        profileImageView.leftAnchor.constraint(equalTo: titleView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        titleView.addSubview(nameLabel)
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: profileImageView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)))
    
    }
    
    @objc func showChatController() {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        
        let loginController = LoginController()
        loginController.modalPresentationStyle = .fullScreen
        loginController.messagesController = self
        present(loginController, animated: true, completion: nil)
    }


}

