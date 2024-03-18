//
//  CustomView.swift
//  TestTask
//
//  Created by User on 18.03.2024.
//

import UIKit

class CustomView: UIView {

    init() {
        super.init(frame: .zero)
        setupUI()
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
        setupSizes()
    }
    
    func setupUI() {

    }

    func setupLayout() {


    }
    
    func setupSizes() {
     
    }
}
