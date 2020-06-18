//
//  MainViewController.swift
//  RNDM
//
//  Created by Beliz Yilmaz on 3/29/20.
//  Copyright © 2020 Beliz Yilmaz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

enum ThoughtCategory : String {
    case funny = "funny"
    case serious = "serious"
    case crazy = "crazy"
    case popular = "popular"
}

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let thoughtTableView = UITableView()
    private var selectedCategory = ThoughtCategory.funny.rawValue
    private var thoughtsCollectionRef: CollectionReference!    
    private var thoughts = [Thought]()
    private var thoughtsListener: ListenerRegistration!
    private var handle: AuthStateDidChangeListenerHandle?
    
    private let segmentedControl: UISegmentedControl = {
        let items = ["funny", "serious", "crazy", "popular"]
        let sc = UISegmentedControl(items: items)
        sc.selectedSegmentIndex = 0
        sc.backgroundColor = .customOrange
        sc.defaultConfiguration()
        sc.selectedConfiguration()
        sc.addTarget(self, action: #selector(categoryChangedInMain(_:)), for: .valueChanged)
        return sc
    }()
    
    func setListener() {
        if selectedCategory == ThoughtCategory.popular.rawValue {
            thoughtsListener = thoughtsCollectionRef
                .order(by: NUM_LIKES, descending: true)
                .addSnapshotListener {
                (snapshot, error) in
                if let err = error {
                    debugPrint("error catching docs: \(err)")
                } else {
                    self.thoughts.removeAll()
                    self.thoughts = Thought.parseData(snapshot: snapshot)
                    self.thoughtTableView.reloadData()
                }
            }
        } else {
            thoughtsListener = thoughtsCollectionRef
                .whereField(CATEGORY, isEqualTo: selectedCategory)
                .order(by: TIMESTAMP, descending: true)
                .addSnapshotListener {
                (snapshot, error) in
                if let err = error {
                    debugPrint("error catching docs: \(err)")
                } else {
                    self.thoughts.removeAll()
                    self.thoughts = Thought.parseData(snapshot: snapshot)
                    self.thoughtTableView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addButtons()
        setupLayout()
        setupTableView()
        
        thoughtsCollectionRef = Firestore.firestore().collection(THOUGHTS_REF)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user == nil {
                let loginVC = LoginViewController()
                self.present(loginVC, animated: true, completion: nil)
            } else {
                self.setListener()
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if thoughtsListener != nil {
            thoughtsListener.remove()
        }
    }
  
    @objc func categoryChangedInMain(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            selectedCategory = ThoughtCategory.funny.rawValue
        case 1:
            selectedCategory = ThoughtCategory.serious.rawValue
        case 2:
            selectedCategory = ThoughtCategory.crazy.rawValue
        default:
            selectedCategory = ThoughtCategory.popular.rawValue
        }
        thoughtsListener.remove()
        setListener()
    }
    
    private func addButtons() {
        let thoughtButton = UIBarButtonItem(image: UIImage(named: "addThoughtIcon"), style: .done, target: self, action: #selector(addThought))
        let signoutButton = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logoutButtonTapped))
        self.navigationItem.rightBarButtonItem  = thoughtButton
        self.navigationItem.leftBarButtonItem = signoutButton
    }
    
    @objc private func addThought() {
        let thoughtViewController = ThoughtViewController()
        navigationController?.pushViewController(thoughtViewController, animated: true)
    }
    
    @objc private func logoutButtonTapped() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signoutError as NSError {
            debugPrint("Error signing out: \(signoutError)")
        }
    }
    
    private func setupLayout() {
        view.addSubview(segmentedControl)

        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 32).isActive = true
        segmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        segmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
    }
    
    private func setupTableView() {
        view.addSubview(thoughtTableView)
        thoughtTableView.separatorStyle = .none
        thoughtTableView.dataSource = self
        thoughtTableView.delegate = self
        thoughtTableView.estimatedRowHeight = 80
        thoughtTableView.rowHeight = UITableView.automaticDimension
        thoughtTableView.register(ThoughtTableViewCell.self, forCellReuseIdentifier: "cell")
        thoughtTableView.translatesAutoresizingMaskIntoConstraints = false
        thoughtTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        thoughtTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        thoughtTableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16).isActive = true
        thoughtTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thoughts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ThoughtTableViewCell {
            cell.configureCell(thought: thoughts[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //    performSegue(withIdentifier: "CommentViewController", sender: thoughts[indexPath.row])
        let thought = thoughts[indexPath.row]
        let commentVC = CommentViewController()
        navigationController?.pushViewController(commentVC, animated: true)
        commentVC.thought = thought
     //   self.show(commentVC, sender: self)
    }

    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CommentViewController" {
             if let destinationVC = segue.destination as? CommentViewController {
                 if let thought = sender as? Thought {
                    destinationVC.thought = thought
                }
            }
        }
        
    }*/
}
