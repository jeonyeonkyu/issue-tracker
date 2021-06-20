//
//  FilterListCell.swift
//  IssueTracker
//
//  Created by Lia on 2021/06/20.
//

import UIKit

class FilterListCell: UICollectionViewListCell {
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var newBgConfiguration = UIBackgroundConfiguration.listGroupedCell()
        newBgConfiguration.backgroundColor = .systemBackground
        backgroundConfiguration = newBgConfiguration
        accessories = isSelected ? [.checkmark()] : []
    }
}
