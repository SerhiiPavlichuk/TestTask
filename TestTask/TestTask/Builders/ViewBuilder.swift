//
//  ViewBuilder.swift
//  TestTask
//
//  Created by User on 18.03.2024.
//

import UIKit

final class ViewBuilder {
    private var backgroundColor: UIColor = .white
    private var cornerRadius: Int = 30

    func setBackgroundColor(_ color: UIColor) -> ViewBuilder {
        self.backgroundColor = color
        return self
    }
    
    func setCornerRadius(_ radius: Int) -> ViewBuilder {
        self.cornerRadius = radius
        return self
    }
    
    func build() -> UIView {
        let view = UIView()
        view.backgroundColor = backgroundColor
        view.layer.cornerRadius = CGFloat(cornerRadius)
        view.layer.cornerCurve = .continuous
        return view
    }
}
