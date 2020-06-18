//
//  CommentViewController.swift
//  RNDM
//
//  Created by Beliz Yilmaz on 6/16/20.
//  Copyright © 2020 Beliz Yilmaz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var thought: Thought!
    var comments = [Comment]()
    var thoughtRef: DocumentReference!
    let firestore = Firestore.firestore()
    var username: String!
    var commentListener: ListenerRegistration!
    
    private let commentTableView = UITableView()
    private let keyboardView = UIView()
    
    private let commentTextField: UITextField = {
       let field = UITextField()
       field.placeholder = "Add comment..."
       field.font = UIFont(name: "AvenirNext", size: 13)
       field.textColor = .darkGray
       field.borderStyle = .none
       field.translatesAutoresizingMaskIntoConstraints = false
       return field
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .contactAdd)
        button.addTarget(self, action: #selector(commentButtonTapped), for: .touchUpInside)
        button.tintColor = .darkGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private func commentButtonTapped() {
        guard let commentText = commentTextField.text else { return }
        
        firestore.runTransaction({ (transaction, errorPointer) -> Any? in
            let thoughtDocument: DocumentSnapshot
            
            do {
                try thoughtDocument = transaction.getDocument(Firestore.firestore().collection(THOUGHTS_REF).document(self.thought.documentId))
            } catch let error as NSError {
                debugPrint("Fetch error: \(error.localizedDescription)")
                return nil
            }
            guard let oldNumComments = thoughtDocument.data()?[NUM_COMMENTS] as? Int else { return nil }
            transaction.updateData([NUM_COMMENTS : oldNumComments + 1], forDocument: self.thoughtRef)
            let newCommentRef = self.firestore.collection(THOUGHTS_REF).document(self.thought.documentId).collection(COMMENTS_REF).document()
            transaction.setData([
                COMMENT_TXT : commentText,
                TIMESTAMP : FieldValue.serverTimestamp(),
                USERNAME : self.username
            ], forDocument: newCommentRef)
            return nil
        }) { (object, error) in
            if let error = error {
                debugPrint("Transaction failed: \(error)")
            } else {
                self.commentTextField.text = ""
                self.commentTextField.resignFirstResponder()
            }
        }
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        view.addSubview(keyboardView)
        view.addSubview(commentTextField)
        view.addSubview(addButton)
        
        setupTableView()
        setupLayout()
        
        thoughtRef = firestore.collection(THOUGHTS_REF).document(thought.documentId)
        if let name = Auth.auth().currentUser?.displayName {
            username = name
        }
        super.viewDidLoad()
        self.view.bindToKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        commentListener = firestore.collection(THOUGHTS_REF).document(self.thought.documentId).collection(COMMENTS_REF)
            .order(by: TIMESTAMP, descending: false)
            .addSnapshotListener({ (snapshot, error) in
            guard let snapshot = snapshot else {
                debugPrint("Error fetching comments: \(error!)")
                return
            }
            self.comments.removeAll()
            self.comments = Comment.parseData(snapshot: snapshot)
            self.commentTableView.reloadData()
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        commentListener.remove()
    }
    
    private func setupTableView() {
        view.addSubview(commentTableView)
        commentTableView.separatorStyle = .none
        commentTableView.dataSource = self
        commentTableView.delegate = self
        commentTableView.estimatedRowHeight = 80
        commentTableView.rowHeight = UITableView.automaticDimension
        commentTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "cell")
        commentTableView.translatesAutoresizingMaskIntoConstraints = false
        commentTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        commentTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        commentTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        commentTableView.bottomAnchor.constraint(equalTo: keyboardView.topAnchor).isActive = true
    }
    
    private func setupLayout() {
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        keyboardView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        keyboardView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        keyboardView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        keyboardView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        commentTextField.rightAnchor.constraint(equalTo: keyboardView.rightAnchor, constant: -20).isActive = true
        commentTextField.leftAnchor.constraint(equalTo: keyboardView.leftAnchor, constant: 20).isActive = true
        commentTextField.centerYAnchor.constraint(equalTo: keyboardView.centerYAnchor).isActive = true

        addButton.rightAnchor.constraint(equalTo: keyboardView.rightAnchor, constant: -12).isActive = true
        addButton.centerYAnchor.constraint(equalTo: keyboardView.centerYAnchor).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = commentTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CommentTableViewCell {
            cell.configureCell(comment: comments[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}
