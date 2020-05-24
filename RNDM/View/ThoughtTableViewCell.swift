//
//  ThoughtTableViewCell.swift
//  RNDM
//
//  Created by Beliz Yilmaz on 5/12/20.
//  Copyright © 2020 Beliz Yilmaz. All rights reserved.
//

import Foundation
import UIKit

class ThoughtTableViewCell: UITableViewCell {
    
    var thought: Thought? {
        didSet {
            guard let thoughtItem = thought else { return }
            if let username = thoughtItem.username {
                usernameLabel.text = username
            }
            if let thoughtText = thoughtItem.thoughtText {
                thoughtLabel.text = thoughtText
            }
            if let timestamp = thoughtItem.timestamp {
                timestampLabel.text = "\(timestamp)"
            }
            if let numLikes = thoughtItem.numLikes {
                likesImageView.image = UIImage(named: "starIconFilled")
                likesNumLabel.text = "\(numLikes)"
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        likesImageView.image = UIImage(named: "starIconFilled")
        
        self.contentView.addSubview(usernameLabel)
        self.contentView.addSubview(timestampLabel)
        self.contentView.addSubview(thoughtLabel)
        self.contentView.addSubview(likesImageView)
        self.contentView.addSubview(likesNumLabel)
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
    
    let thoughtLabel: UILabel = {
        let thoughtLabel = UILabel()
        thoughtLabel.font = UIFont(name: "AvenirNext", size: 14)
        thoughtLabel.textColor = .darkGray
        thoughtLabel.translatesAutoresizingMaskIntoConstraints = false
        thoughtLabel.numberOfLines = 0
        return thoughtLabel
    }()
    
    let likesImageView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let likesNumLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext", size: 14)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func configureCell(thought: Thought) {
        usernameLabel.text = thought.username
        thoughtLabel.text = thought.thoughtText
        likesNumLabel.text = String(thought.numLikes)
    }
    
    func setupTableViewCell() {
        usernameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 30).isActive = true
        
        timestampLabel.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor).isActive = true
        timestampLabel.leftAnchor.constraint(equalTo: usernameLabel.rightAnchor, constant: 8).isActive = true
        
        thoughtLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 30).isActive = true
        thoughtLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8).isActive = true
        thoughtLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -30).isActive = true
        
        likesImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        likesImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        likesImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 30).isActive = true
        likesImageView.topAnchor.constraint(equalTo: thoughtLabel.bottomAnchor, constant: 4).isActive = true
        
        likesNumLabel.leftAnchor.constraint(equalTo: likesImageView.rightAnchor, constant: 4).isActive = true
        likesNumLabel.centerYAnchor.constraint(equalTo: likesImageView.centerYAnchor).isActive = true
        likesNumLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20).isActive = true
        
    }
}
