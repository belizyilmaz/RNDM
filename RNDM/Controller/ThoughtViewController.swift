//
//  ThoughtViewController.swift
//  RNDM
//
//  Created by Beliz Yilmaz on 3/30/20.
//  Copyright © 2020 Beliz Yilmaz. All rights reserved.
//

import UIKit

extension UIColor {
    static var customOrange = UIColor(red: 0.961, green: 0.510, blue: 0.047, alpha: 1.0)
}

extension UISegmentedControl {
    func defaultConfiguration(font: UIFont = UIFont.systemFont(ofSize: 12), color: UIColor = UIColor.white) {
        let normalTitleAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.setTitleTextAttributes(normalTitleAttributes, for: .normal)
    }

    func selectedConfiguration(font: UIFont = UIFont.boldSystemFont(ofSize: 12), color: UIColor = UIColor.customOrange) {
        let selectedAttributes = [NSAttributedString.Key.foregroundColor: UIColor.customOrange]
        self.setTitleTextAttributes(selectedAttributes, for: .selected)
    }
}

class ThoughtViewController: UIViewController, UITextViewDelegate {
    
    private let segmentedControl: UISegmentedControl = {
        let items = ["funny", "serious", "crazy"]
        let sc = UISegmentedControl(items: items)
        sc.selectedSegmentIndex = 0
        sc.backgroundColor = .customOrange
        sc.defaultConfiguration()
        sc.selectedConfiguration()
        return sc
    }()
    
    private let usernameTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Username"
        field.font = UIFont(name: "AvenirNext", size: 14)
        field.textColor = .darkGray
        return field
    }()
    
    private let thoughtText: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: "AvenirNext", size: 14)
        textView.backgroundColor = UIColor(red: 0.667, green: 0.667, blue: 0.667, alpha: 0.15)
        textView.layer.cornerRadius = 4
        textView.text = "My random thought..."
        textView.textColor = .lightGray
        return textView
    }()
    
    private let postButton: UIButton = {
        let button = UIButton()
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 17)
        button.backgroundColor = .customOrange
        button.layer.cornerRadius = 4
        return button
    }()
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        thoughtText.text = ""
        thoughtText.textColor = .darkGray
    }
    
    private func setupLayout() {
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 32).isActive = true
        segmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        segmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true

        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 12).isActive = true
        usernameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        usernameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true

        thoughtText.translatesAutoresizingMaskIntoConstraints = false
        thoughtText.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 12).isActive = true
        thoughtText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        thoughtText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        thoughtText.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        postButton.translatesAutoresizingMaskIntoConstraints = false
        postButton.topAnchor.constraint(equalTo: thoughtText.bottomAnchor, constant: 8).isActive = true
        postButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        postButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        postButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(segmentedControl)
        view.addSubview(thoughtText)
        view.addSubview(usernameTextField)
        view.addSubview(postButton)
        thoughtText.delegate = self
        setupLayout()
    }

}
