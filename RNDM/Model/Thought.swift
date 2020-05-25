//
//  User.swift
//  RNDM
//
//  Created by Beliz Yilmaz on 5/12/20.
//  Copyright © 2020 Beliz Yilmaz. All rights reserved.
//

import Foundation
import UIKit
import Firebase
    
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
    
    class func parseData(snapshot: QuerySnapshot?) -> [Thought] {
        var thoughts = [Thought]()
        
        guard let snap = snapshot else { return thoughts }
        for document in snap.documents {
            let data = document.data()
            let username = data[USERNAME] as? String ?? "Anonymous"
            let stamp = data[TIMESTAMP] as? Timestamp ?? nil
            let timestamp = stamp!.dateValue()
            let thoughtText = data[THOUGHT_TXT] as? String ?? ""
            let numLikes = data[NUM_LIKES] as? Int ?? 0
            let numComments = data[NUM_COMMENTS] as? Int ?? 0
            let documentId = document.documentID
            
            let newThought = Thought(username: username, timestamp: timestamp, thoughtText: thoughtText, numLikes: numLikes, numComments: numComments, documentId: documentId)
            thoughts.append(newThought)
        }
        
        return thoughts
    }
}

