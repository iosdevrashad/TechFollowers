//
//  UIView+Ext.swift
//  Followers
//
//  Created by Rashad Surratt on 1/23/23.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        for view in views { addSubview(view) }
    }
}
