//
//  UIVIew+Extension.swift
//  TestTask
//
//  Created by User on 18.03.2024.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
        }
    }
}
