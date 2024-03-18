//
//  Images.swift
//  TestTask
//
//  Created by User on 18.03.2024.
//

import UIKit

enum Images: String {
    case deleteImage = "deleteImage"
    case acceptImage = "acceptImage"
    case emptyTrashImage = "emptyTrashImage"
    
    func setImage() -> UIImage {
        return UIImage(named: self.rawValue) ?? UIImage()
    }
}

