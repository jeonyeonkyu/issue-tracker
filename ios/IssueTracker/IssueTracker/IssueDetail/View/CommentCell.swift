//
//  CommentCell.swift
//  IssueTracker
//
//  Created by 지북 on 2021/06/22.
//

import UIKit
import MarkdownView

class CommentCell: UITableViewCell, UINibCreatable {

    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var elapsedTimeLabel: UILabel!
    @IBOutlet private weak var commentView: MarkdownView!
    
    func fillUI(_ comment: Comment) {
        userNameLabel.text = comment.author.name
        commentView.load(markdown: comment.contents)
    }
}
