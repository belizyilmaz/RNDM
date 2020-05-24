//
//  MainViewController.swift
//  RNDM
//
//  Created by Beliz Yilmaz on 3/29/20.
//  Copyright © 2020 Beliz Yilmaz. All rights reserved.
//

import UIKit
import Firebase

enum ThoughtCategory : String {
    case funny = "funny"
    case serious = "serious"
    case crazy = "crazy"
    case popular = "popular"
}

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    private let thoughtTableView = UITableView()
    private var selectedCategory = ThoughtCategory.funny.rawValue
    private var thoughtsCollectionRef: CollectionReference!    
    private var thoughts = [Thought]()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        thoughtsCollectionRef.getDocuments { (snapshot, error) in
            if let err = error {
                debugPrint("error catching docs: \(err)")
            } else {
                guard let snap = snapshot else { return }
                for document in snap.documents {
                    let data = document.data()
                    let username = data[USERNAME] as? String ?? "Anonymous"
                    let timestamp = data[TIMESTAMP] as? Date ?? Date()
                    let thoughtText = data[THOUGHT_TXT] as? String ?? ""
                    let numLikes = data[NUM_LIKES] as? Int ?? 0
                    let numComments = data[NUM_COMMENTS] as? Int ?? 0
                    let documentId = document.documentID
                    
                    let newThought = Thought(username: username, timestamp: timestamp, thoughtText: thoughtText, numLikes: numLikes, numComments: numComments, documentId: documentId)
                    self.thoughts.append(newThought)
                }
                self.thoughtTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addButton()
        setupLayout()
        setupTableView()
        
        thoughtsCollectionRef = Firestore.firestore().collection(THOUGHTS_REF)
    }
  
    @objc func categoryChangedInMain(_ sender: UISegmentedControl) {
          switch sender.selectedSegmentIndex {
        case 0:
            selectedCategory = ThoughtCategory.funny.rawValue
        case 1:
            selectedCategory = ThoughtCategory.serious.rawValue
        case 2:
            selectedCategory = ThoughtCategory.popular.rawValue
        default:
            selectedCategory = ThoughtCategory.crazy.rawValue
        }
    }
    
    @objc func addThought() {
        let thoughtViewController = ThoughtViewController()
        navigationController?.pushViewController(thoughtViewController, animated: true)
    }
    
    private func addButton() {
        let thoughtButton = UIBarButtonItem(image: UIImage(named: "addThoughtIcon"), style: .done, target: self, action: #selector(addThought))
        self.navigationItem.rightBarButtonItem  = thoughtButton
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
}
