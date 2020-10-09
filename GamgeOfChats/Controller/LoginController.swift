//
//  LoginViewController.swift
//  GamgeOfChats
//
//  Created by Veaceslav Chirita on 10/9/20.
//  Copyright © 2020 Veaceslav Chirita. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    private lazy var inputsContainerVew: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var loginRegistrationButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 80, green: 101, blue: 161)
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleRegisterLoginTap), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private lazy var nameSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textContentType = .emailAddress
        return tf
    }()
    
    private lazy var emailSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
//        tf.isSecureTextEntry = true
        return tf
    }()
    
    private lazy var passwordSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "wic")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(red: 61, green: 91, blue: 151)
        
        view.addSubview(inputsContainerVew)
        view.addSubview(loginRegistrationButton)
        view.addSubview(profileImageView)
        
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupProfileImageView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func handleRegisterLoginTap() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let name = emailTextField.text
        else {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error)
                return
            }
            
            let ref = Database.database().reference(fromURL: "https://gameofchats-7f64f.firebaseio.com/ ")
            let values = [
                "name": name,
                "email": email
            ]
            
            ref.updateChildValues(values) { (err, ref) in
                if err != nil {
                    print(err?.localizedDescription)
                    return
                }
                
                print("Saved user successfully")
            }
            
            if let user = result?.user {
                print(user)
            }
        }
    }
    
    private func setupProfileImageView() {
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: inputsContainerVew.topAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    private func setupInputsContainerView() {
        inputsContainerVew.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerVew.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerVew.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerVew.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        inputsContainerVew.addSubview(nameTextField)
        inputsContainerVew.addSubview(nameSeparator)
        inputsContainerVew.addSubview(emailTextField)
        inputsContainerVew.addSubview(emailSeparator)
        inputsContainerVew.addSubview(passwordTextField)
        inputsContainerVew.addSubview(passwordSeparator)
        
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerVew.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerVew.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerVew.widthAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: inputsContainerVew.heightAnchor, multiplier: 1/3).isActive = true
        
        nameSeparator.leftAnchor.constraint(equalTo: inputsContainerVew.leftAnchor).isActive = true
        nameSeparator.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparator.widthAnchor.constraint(equalTo: inputsContainerVew.widthAnchor).isActive = true
        nameSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerVew.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerVew.widthAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: inputsContainerVew.heightAnchor, multiplier: 1/3).isActive = true
        
        emailSeparator.leftAnchor.constraint(equalTo: inputsContainerVew.leftAnchor).isActive = true
        emailSeparator.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparator.widthAnchor.constraint(equalTo: inputsContainerVew.widthAnchor).isActive = true
        emailSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerVew.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerVew.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: inputsContainerVew.heightAnchor, multiplier: 1/3).isActive = true
        
        passwordSeparator.leftAnchor.constraint(equalTo: inputsContainerVew.leftAnchor).isActive = true
        passwordSeparator.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        passwordSeparator.widthAnchor.constraint(equalTo: inputsContainerVew.widthAnchor).isActive = true
        passwordSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    private func setupLoginRegisterButton() {
        loginRegistrationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegistrationButton.topAnchor.constraint(equalTo: inputsContainerVew.bottomAnchor, constant: 12).isActive = true
        loginRegistrationButton.widthAnchor.constraint(equalTo: inputsContainerVew.widthAnchor).isActive = true
        loginRegistrationButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}

extension UIColor {
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
}
