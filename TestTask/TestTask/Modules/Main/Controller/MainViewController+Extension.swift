//
//  MainViewController+Extension.swift
//  TestTask
//
//  Created by User on 18.03.2024.
//

import UIKit

extension MainViewController: ViewWithUserImageDataSource {
    func imageFromLibrary(_ view: ViewWithUserImage) -> UIImage? {
        return UIImage(data: viewModel.currentImage?.data ?? Data())
    }
}

extension MainViewController: ViewWithUserImageDelegate {
    func deletePressed() {
        viewModel.addImagetoTrash()
        loadNewImage()
    }
    
    func savePressed() {
        viewModel.saveImage()
        loadNewImage()
    }
}

extension MainViewController: TrashContainerViewDataSource {
    func countOfImages(_ view: TrashContainerView) -> Int? {
        GlobalVariables.photosInTrash.count
    }
}

extension MainViewController: TrashContainerViewDelegate {
    func emptyTrashPressed() {
        Task {
            await viewModel.emptyTrash()
            await trashContainerView.reloadData()
        }
    }
}

extension MainViewController: MainViewModelProtocol {
    func imagesAreFinish() {
        noImagesToContinue.isHidden = false
    }
    
    func assetsLoaded() {
        loadNewImage()
    }
    
    func showAlert(with error: ErrorType) {
        let alert = AlertManager(type: error, delegate: self)
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
