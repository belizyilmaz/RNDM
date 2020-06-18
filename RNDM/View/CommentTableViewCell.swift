//
//  CommentTableViewCell.swift
//  RNDM
//
//  Created by Beliz Yilmaz on 6/18/20.
//  Copyright © 2020 Beliz Yilmaz. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(usernameLabel)
        self.contentView.addSubview(timestampLabel)
        self.contentView.addSubview(commentLabel)
        selectionStyle = .none
        setupTableViewCell()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Medium", size: 20)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
       
    let timestampLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.font = UIFont(name: "AvenirNext", size: 10)
        timeLabel.textColor = .darkGray
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        return timeLabel
    }()
       
    let commentLabel: UILabel = {
        let thoughtLabel = UILabel()
        thoughtLabel.font = UIFont(name: "AvenirNext", size: 14)
        thoughtLabel.textColor = .darkGray
        thoughtLabel.translatesAutoresizingMaskIntoConstraints = false
        thoughtLabel.numberOfLines = 0
        return thoughtLabel
    }()
    
    func configureCell(comment: Comment) {
        usernameLabel.text = comment.username
        commentLabel.text = comment.commentText
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, hh:mm"
        let timestamp = formatter.string(from: comment.timestamp)
        timestampLabel.text = timestamp
    }
    
    func setupTableViewCell() {
        usernameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 30).isActive = true
        
        timestampLabel.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor).isActive = true
        timestampLabel.leftAnchor.constraint(equalTo: usernameLabel.rightAnchor, constant: 8).isActive = true
        
        commentLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 30).isActive = true
        commentLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8).isActive = true
        commentLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -30).isActive = true
        commentLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -14).isActive = true
    }
}
