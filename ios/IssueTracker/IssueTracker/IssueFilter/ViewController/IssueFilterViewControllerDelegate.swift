//
//  IssueFilterViewControllerDelegate.swift
//  IssueTracker
//
//  Created by Lia on 2021/06/22.
//

import Foundation

protocol IssueFilterViewControllerDelegate: AnyObject {
    func issueFilterViewControllerDidCancel()
    func issueFilterViewControllerDidSave()
}
