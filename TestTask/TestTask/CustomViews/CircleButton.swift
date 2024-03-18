//
//  CircleButton.swift
//  TestTask
//
//  Created by User on 18.03.2024.
//

import UIKit

final class CircleButton: UIButton {
    
    //MARK: - Enum
    
    enum ButtonType {
        case delete
        case save
        
        var image: UIImage {
            switch self {
            case .delete:
                return Images.deleteImage.setImage()
            case .save:
                return Images.acceptImage.setImage()
            }
        }
        
        var color: UIColor {
            switch self {
            case .delete:
                return .deleteButtonColor
            case .save:
                return .saveButtonColor
            }
        }
    }
    
    //MARK: - Property
    
    let type: ButtonType
    
    //MARK: - Init
    
    init(type: ButtonType) {
        self.type = type
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureButton()
    }
    
    //MARK: - Method
    
    private func configureButton() {
        clipsToBounds = true
        layer.cornerRadius = CGFloat(bounds.height / 2)
        layer.cornerCurve = .continuous
        setImage(type.image, for: .normal)
        backgroundColor = type.color
     
    }
}
