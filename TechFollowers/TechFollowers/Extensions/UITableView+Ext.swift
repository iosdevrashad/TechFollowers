//
//  UITableView+Ext.swift
//  Followers
//
//  Created by Rashad Surratt on 1/23/23.
//

import UIKit

// Remove Excess Cells for table view, may not need after update.

extension UITableView {

    func reloadDataOnMainThread() {
        DispatchQueue.main.async { self.reloadData() }
    }
    
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
