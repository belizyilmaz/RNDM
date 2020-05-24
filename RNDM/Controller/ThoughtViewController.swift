//
//  ThoughtViewController.swift
//  RNDM
//
//  Created by Beliz Yilmaz on 3/30/20.
//  Copyright © 2020 Beliz Yilmaz. All rights reserved.
//

import UIKit
import FirebaseFirestore

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
    
    private var selectedCategory = ThoughtCategory.funny.rawValue
    
    private let segmentedControl: UISegmentedControl = {
        let items = ["funny", "serious", "crazy"]
        let sc = UISegmentedControl(items: items)
        sc.selectedSegmentIndex = 0
        sc.backgroundColor = .customOrange
        sc.defaultConfiguration()
        sc.selectedConfiguration()
        sc.addTarget(self, action: #selector(categoryChanged(_:)), for: .valueChanged)
        return sc
    }()
    
    @objc func categoryChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            selectedCategory = ThoughtCategory.funny.rawValue
        case 1:
            selectedCategory = ThoughtCategory.serious.rawValue
        default:
            selectedCategory = ThoughtCategory.crazy.rawValue
        }
    }
    
    private let usernameTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Username"
        field.font = UIFont(name: "AvenirNext", size: 14)
        field.textColor = .darkGray
        return field
    }()
    
    private let thoughtTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: "AvenirNext", size: 14)
        textView.backgroundColor = UIColor(red: 0.667, green: 0.667, blue: 0.667, alpha: 0.15)
        textView.layer.cornerRadius = 4
        textView.text = "My random thought..."
        textView.textColor = .lightGray
        return textView
    }()
    
    @objc func postButtonTapped() {
        guard let username = usernameTextField.text else { return }
        guard let thoughtText = thoughtTextView.text else { return }
        print("Post button tapped")
        Firestore.firestore().collection(THOUGHTS_REF).addDocument(data: [
            CATEGORY: selectedCategory,
            NUM_COMMENTS: 0,
            NUM_LIKES: 0,
            THOUGHT_TXT: thoughtText,
            TIMESTAMP: FieldValue.serverTimestamp(),
            USERNAME: username
        ]) { (err) in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                self.navigationController?.popViewController(animated: true)
                print("Works")
            }
        }
    }
    
    private let postButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(postButtonTapped), for: .touchUpInside)
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 17)
        button.backgroundColor = .customOrange
        button.layer.cornerRadius = 4
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(segmentedControl)
        view.addSubview(thoughtTextView)
        view.addSubview(usernameTextField)
        view.addSubview(postButton)
        thoughtTextView.delegate = self
        setupLayout()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = .darkGray
    }
    
    private func setupLayout() {
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 32).isActive = true
        segmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        segmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true

        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 12).isActive = true
        usernameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        usernameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true

        thoughtTextView.translatesAutoresizingMaskIntoConstraints = false
        thoughtTextView.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 12).isActive = true
        thoughtTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        thoughtTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        thoughtTextView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        postButton.translatesAutoresizingMaskIntoConstraints = false
        postButton.topAnchor.constraint(equalTo: thoughtTextView.bottomAnchor, constant: 8).isActive = true
        postButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        postButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        postButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

    }
    
    

}
