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
    
    weak var delegate: AlertManagerDelegate?
    let type: ErrorType
    
    init(type: ErrorType, delegate: AlertManagerDelegate? = nil) {
        self.type = type
        self.delegate = delegate
    }

    func createAlert() -> UIAlertController {
        let alert = UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)
        configureAlert(alert, for: type)
        return alert
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
    
    private func configureAlert(_ alert: UIAlertController, for type: ErrorType) {
        switch type {
        case .donthavePermission:
            let actionTitle = "Settings"
            let action = UIAlertAction(title: actionTitle, style: .default) {_ in
                self.delegate?.goToSettings()
            }
            alert.addAction(action)
            
     
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                self.delegate?.cancel()
            }
            alert.addAction(cancelAction)
        case .showError, .errorIamgeLoading, .deletionError:
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
