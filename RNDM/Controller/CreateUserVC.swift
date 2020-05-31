//
//  CreateUserVC.swift
//  RNDM
//
//  Created by Beliz Yilmaz on 5/31/20.
//  Copyright © 2020 Beliz Yilmaz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class CreateUserVC: UIViewController {
    
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
     
    private let usernameTextField: UITextField = {
       let field = UITextField()
       field.placeholder = "username: public"
       field.font = UIFont(name: "AvenirNext", size: 14)
       field.textColor = .darkGray
       field.borderStyle = .none
       field.backgroundColor = UIColor.lightGray.withAlphaComponent(0.21)
       field.translatesAutoresizingMaskIntoConstraints = false
       return field
    }()
    
    private let createUserButton: UIButton = {
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
    
    private let cancelButton: UIButton = {
        let button = UIButton()
       button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 17)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(usernameTextField)
        view.addSubview(createUserButton)
        view.addSubview(cancelButton)
        setupLayout()
    }
    
    @objc func createButtonTapped() {
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let username = usernameTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                debugPrint("Error creating user: \(error.localizedDescription)")
            }
            let changeRequest = user?.user.createProfileChangeRequest()
            changeRequest?.displayName = username
            changeRequest?.commitChanges(completion: { (error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                }
            })
            
            guard let userId = user?.user.uid else { return }
            Firestore.firestore().collection(USERS_REF).document(userId).setData([
                USERNAME : username,
                DATE_CREATED : FieldValue.serverTimestamp()
                ]) { (error) in
                
                    if let error = error {
                        debugPrint(error.localizedDescription)
                    } else {
                        self.dismiss(animated: true, completion: nil)
                    }
            }
        }
    }
       
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupLayout() {
        emailTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        emailTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
           
        passwordTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
           
        usernameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        usernameTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16).isActive = true
        usernameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        createUserButton.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20).isActive = true
        createUserButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        createUserButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        createUserButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        cancelButton.topAnchor.constraint(equalTo: createUserButton.bottomAnchor, constant: 8).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}
