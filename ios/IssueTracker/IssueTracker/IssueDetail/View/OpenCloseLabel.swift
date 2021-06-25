//
//  OpenCloseLabel.swift
//  IssueTracker
//
//  Created by 지북 on 2021/06/23.
//

import UIKit

final class OpenCloseLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
}


extension OpenCloseLabel {
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        layer.cornerRadius = 13
        layer.borderWidth = 1
        font = UIFont(descriptor: UIFontDescriptor(name: "System", size: 13), size: 13)
        textAlignment = .center
    }

    func state(_ closed: Bool) {
        if !closed {
            text = "열림"
            backgroundColor = #colorLiteral(red: 0.7802817225, green: 0.9216222763, blue: 0.9998783469, alpha: 1)
            textColor = #colorLiteral(red: 0, green: 0.4784809947, blue: 0.9998757243, alpha: 1)
            layer.borderColor = #colorLiteral(red: 0, green: 0.4784809947, blue: 0.9998757243, alpha: 1).cgColor
            appendImage(imageName: "exclamationmark.circle")
            configureConstraint()
        } else {
            text = "닫힘"
            backgroundColor = #colorLiteral(red: 0.7999212146, green: 0.8314239979, blue: 0.9998793006, alpha: 1)
            textColor = #colorLiteral(red: 0, green: 0.1451903284, blue: 0.9057698846, alpha: 1)
            layer.borderColor = #colorLiteral(red: 0, green: 0.1451903284, blue: 0.9057698846, alpha: 1).cgColor
            appendImage(imageName: "archivebox")
            configureConstraint()
        }
    }
    
    private func configureConstraint() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: intrinsicContentSize.height + 10),
            widthAnchor.constraint(greaterThanOrEqualToConstant: intrinsicContentSize.width + 30)
        ])
    }
    
}
