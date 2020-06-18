//
//  Comment.swift
//  RNDM
//
//  Created by Beliz Yilmaz on 6/18/20.
//  Copyright © 2020 Beliz Yilmaz. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Comment {
    
    private(set) var username: String!
    private(set) var timestamp: Date!
    private(set) var commentText: String!

    init(username: String, timestamp: Date, commentText: String) {
        self.username = username
        self.timestamp = timestamp
        self.commentText = commentText
    }
    
    class func parseData(snapshot: QuerySnapshot?) -> [Comment] {
        var comments = [Comment]()

        guard let snap = snapshot else { return comments }
        for document in snap.documents {
            let data = document.data()
            let username = data[USERNAME] as? String ?? "Anonymous"
            let stamp = data[TIMESTAMP] as? Timestamp ?? nil
            let timestamp = stamp!.dateValue()
            let commentText = data[COMMENT_TXT] as? String ?? ""
        
            let newComment = Comment(username: username, timestamp: timestamp, commentText: commentText)
            comments.append(newComment)
        }

        return comments
    }
    
}
