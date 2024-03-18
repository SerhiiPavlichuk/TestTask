//
//  AlertManager.swift
//  TestTask
//
//  Created by User on 18.03.2024.
//

import UIKit

protocol AlertManagerDelegate: AnyObject {
    func goToSettings()
    func cancel()
}

struct AlertManager {
    
    weak var delegate: AlertManagerDelegate?

    func createAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Oops, we can't load photos", message: "Please give acces to library in settings", preferredStyle: .alert)
        configureAlert(alert)
        return alert
    }
    
    private func configureAlert(_ alert: UIAlertController) {
        let actionTitle = "Settings"
        let action = UIAlertAction(title: actionTitle, style: .default) {_ in
            self.delegate?.goToSettings()
        }
        alert.addAction(action)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {_ in
            self.delegate?.cancel()
        }
        alert.addAction(cancelAction)
    }
}
