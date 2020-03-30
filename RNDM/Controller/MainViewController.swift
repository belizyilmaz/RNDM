//
//  MainViewController.swift
//  RNDM
//
//  Created by Beliz Yilmaz on 3/29/20.
//  Copyright © 2020 Beliz Yilmaz. All rights reserved.
//

import UIKit

enum ThoughtCategory : String {
    
    case funny = "funny"
    case serious = "serious"
    case crazy = "crazy"
    case popular = "popular"

}

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addButton()
    }
    
    @objc func addThought() {
        let thoughtViewController = ThoughtViewController()
        navigationController?.pushViewController(thoughtViewController, animated: true)
    }
    
    private func addButton() {
        let thoughtButton = UIBarButtonItem(image: UIImage(named: "addThoughtIcon"), style: .done, target: self, action: #selector(addThought))
        self.navigationItem.rightBarButtonItem  = thoughtButton
        

    }
    
}
