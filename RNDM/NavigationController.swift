//
//  NavigationController.swift
//  RNDM
//
//  Created by Beliz Yilmaz on 3/29/20.
//  Copyright © 2020 Beliz Yilmaz. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customOrange = UIColor(red: 0.961, green: 0.510, blue: 0.047, alpha: 1.0)
        UINavigationBar.appearance().tintColor = customOrange
        UINavigationBar.appearance().barTintColor = UIColor(red: 0.212, green: 0.212, blue: 0.212, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: customOrange]
        

    }
    
}
