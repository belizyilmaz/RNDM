//
//  LoginViewController.swift
//  RNDM
//
//  Created by Beliz Yilmaz on 5/31/20.
//  Copyright © 2020 Beliz Yilmaz. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {
    
    private let emailTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "email"
        field.font = UIFont(name: "AvenirNext", size: 14)
        field.textColor = .darkGray
        field.borderStyle = .none
        field.backgroundColor = UIColor.lightGray.withAlphaComponent(0.21)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
 
    private let passwordTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "password"
        field.font = UIFont(name: "AvenirNext", size: 14)
        field.textColor = .darkGray
        field.borderStyle = .none
        field.backgroundColor = UIColor.lightGray.withAlphaComponent(0.21)
        field.isSecureTextEntry.toggle()
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 17)
        button.backgroundColor = .customOrange
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let noAccountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext", size: 12)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Don't have an account?"
        return label
    }()
    
     private let createButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        button.setTitle("Create User", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 17)
        button.backgroundColor = .customOrange
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(noAccountLabel)
        view.addSubview(createButton)
        setupLayout()
    }
    
    @objc func loginButtonTapped() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                debugPrint("Error signing in: \(error)")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func createButtonTapped() {
        let createUserViewController = CreateUserVC()
        present(createUserViewController, animated: true, completion: nil)
        print("button tapped")
    }
    
    private func setupLayout() {
        emailTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        emailTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        passwordTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        noAccountLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 35).isActive = true
        noAccountLabel.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor).isActive = true
        
        createButton.topAnchor.constraint(equalTo: noAccountLabel.bottomAnchor, constant: 8).isActive = true
        createButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        createButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        createButton.centerXAnchor.constraint(equalTo: noAccountLabel.centerXAnchor).isActive = true
    }
}
