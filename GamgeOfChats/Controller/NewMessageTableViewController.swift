//
//  NewMessageTableViewController.swift
//  GamgeOfChats
//
//  Created by Veaceslav Chirita on 10/10/20.
//  Copyright © 2020 Veaceslav Chirita. All rights reserved.
//

import UIKit
import Firebase

class NewMessageTableViewController: UITableViewController {
    
    let cellId = "cellId"
    var users: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()
    }
    
    private func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded) { [weak self] (snapshot) in
            guard let self = self else { return }
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User(name: dictionary["name"] as! String, email: dictionary["email"] as! String)
                self.users.append(user)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
        }
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        return cell
    }
}

class UserCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
