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

extension MainViewController: TrashContainerViewDataSource {
    func countOfImages(_ view: TrashContainerView) -> Int? {
#warning("logic")
        return 0
    }
}

extension MainViewController: TrashContainerViewDelegate {
    func emptyTrashPressed() {
#warning("logic")
    }
}

extension MainViewController: MainViewModelProtocol {
    func showErrorAlert() {
        let alert = AlertManager(type: .error, delegate: self)
        present(alert.createAlert(), animated: true)
    }
    
    func showPermissionsAlert() {
        let alert = AlertManager(type: .permissions, delegate: self)
        present(alert.createAlert(), animated: true)
    }
}

extension MainViewController: AlertManagerDelegate {
    func retry() {
        Task {
            await viewModel.getAllImageAssets()
        }
    }
    
    func goToSettings() {
        openSettings()
    }
    
    func cancel() {
        isHavePermissions = false
    }
}

extension MainViewController: NoPermissionsViewDelegate {
    func showSettings() {
        openSettings()
    }
}
