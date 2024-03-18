//
//  MainViewController+Extension.swift
//  TestTask
//
//  Created by User on 18.03.2024.
//

import UIKit

extension MainViewController: ViewWithUserImageDataSource {
    func imageFromLibrary(_ view: ViewWithUserImage) -> UIImage? {
#warning("logic")
        return UIImage()
    }
}

extension MainViewController: ViewWithUserImageDelegate {
    func deletePressed() {
#warning("logic")
    }
    
    func savePressed() {
#warning("logic")
    }
}
