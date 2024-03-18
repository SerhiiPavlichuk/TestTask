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
    func retry()
}

struct AlertManager {
    
    enum AlertType {
        case permissions
        case error
    }
    
    weak var delegate: AlertManagerDelegate?
    let type: AlertType
    
    init(type: AlertType, delegate: AlertManagerDelegate? = nil) {
        self.type = type
        self.delegate = delegate
    }

    func createAlert() -> UIAlertController {
        let alert = UIAlertController(title: titleFor(type: type), message: messageFor(type: type), preferredStyle: .alert)
        configureAlert(alert, for: type)
        return alert
    }
    
    private func titleFor(type: AlertType) -> String {
        switch type {
        case .permissions:
            return "Oops, we can't load photos"
        case .error:
            return "Oops, error"
        }
    }
    
    private func messageFor(type: AlertType) -> String {
        switch type {
        case .permissions:
            return "Please give acces to library in settings"
        case .error:
            return "Error when try fetch photos"
        }
    }
    
    private func configureAlert(_ alert: UIAlertController) {
        let actionTitle = ""
        let action = UIAlertAction(title: actionTitle, style: .default) {_ in
            self.delegate?.goToSettings()
        }
        alert.addAction(action)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {_ in
            self.delegate?.cancel()
        }
        alert.addAction(cancelAction)
    }
    
    private func configureAlert(_ alert: UIAlertController, for type: AlertType) {
        switch type {
        case .permissions:
            let actionTitle = "Settings"
            let action = UIAlertAction(title: actionTitle, style: .default) {_ in
                self.delegate?.goToSettings()
            }
            alert.addAction(action)
            
     
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                self.delegate?.cancel()
            }
            alert.addAction(cancelAction)
        case .error:
            let actionTitle = "Try again"
            let action = UIAlertAction(title: actionTitle, style: .default) {_ in
                self.delegate?.retry()
            }
            alert.addAction(action)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(cancelAction)
        }
    }
}
