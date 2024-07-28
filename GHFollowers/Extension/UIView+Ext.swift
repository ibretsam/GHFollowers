//
//  UIView+Ext.swift
//  GHFollowers
//
//  Created by MasterBi on 27/7/24.
//

import UIKit

extension UIView {
    func addSubViews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
