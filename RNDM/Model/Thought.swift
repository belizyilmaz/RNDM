//
//  User.swift
//  RNDM
//
//  Created by Beliz Yilmaz on 5/12/20.
//  Copyright © 2020 Beliz Yilmaz. All rights reserved.
//

import Foundation
import UIKit


    
class Thought {
    private(set) var username: String!
    private(set) var timestamp: Date!
    private(set) var thoughtText: String!
    private(set) var numLikes: Int!
    private(set) var numComments: Int!
    private(set) var documentId: String!

    init(username: String, timestamp: Date, thoughtText: String, numLikes: Int, numComments: Int, documentId: String) {
        self.username = username
        self.timestamp = timestamp
        self.thoughtText = thoughtText
        self.numLikes = numLikes
        self.numComments = numComments
        self.documentId = documentId
    }
}
/*
    struct Thought {
        let username: String?
        let timestamp: Date?
        let thoughtText: String?
        let numLikes: Int?
        let numComments: Int?
        let documentId: String?
    }
    */
  

