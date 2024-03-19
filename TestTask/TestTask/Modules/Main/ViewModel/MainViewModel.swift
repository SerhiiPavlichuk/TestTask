//
//  MainViewModel.swift
//  TestTask
//
//  Created by User on 18.03.2024.
//

import UIKit
import Photos

protocol MainViewModelProtocol: AnyObject {
    func showAlert(with error: ErrorType)
    func assetsLoaded()
}

final class MainViewModel {
    
    //MARK: - Properties
    
    weak var vc: MainViewModelProtocol?
    
    var assets: [PHAsset] = []
    var currentImage: UIImage?
    
    // MARK: - Init

    func askPermissions() async {
        let status = await PhotoManager.shared.checkPermission()
        if status == .authorized {
            await getAllImageAssets()
        } else if status == .denied {
            DispatchQueue.main.async { [weak self] in
                self?.vc?.showAlert(with: .donthavePermission)
            }
        }
    }
    
    func getAllImageAssets() async {
        do {
            let assets = try await PhotoManager.shared.fetchAllImageAssets()
            let filteredAssets = assets.filter { asset in
                !GlobalVariables.processedPhotos.contains(asset.localIdentifier) &&
                !GlobalVariables.photosInTrash.contains(asset.localIdentifier)
            }
            self.assets = filteredAssets
            vc?.assetsLoaded()
        } catch {
            vc?.showAlert(with: .showError)
        }
    }
    
    func loadImage(with size: CGSize) async {
        do {
            guard let asset = assets.first else { return }
            let image = try await PhotoManager.shared.fetchImage(for: asset, size: size)
            currentImage = image
        } catch {
            vc?.showAlert(with: .errorIamgeLoading)
        }
    }
    
    func addImagetoTrash() {
        guard let asset = assets.first else { return }
        assets.removeFirst()
        GlobalVariables.photosInTrash.append(asset.localIdentifier)
    }
    
    func saveImage() {
        guard let asset = assets.first else { return }
        assets.removeFirst()
        GlobalVariables.processedPhotos.append(asset.localIdentifier)
    }
    
    func emptyTrash() async {
        do {
            let _ = try await PhotoManager.shared.deletePhotos(with: GlobalVariables.photosInTrash)
            GlobalVariables.photosInTrash.removeAll()
        } catch {
            vc?.showAlert(with: .deletionError)
        }

    }
}
