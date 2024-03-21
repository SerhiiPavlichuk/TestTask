//
//  MainViewModel.swift
//  TestTask
//
//  Created by User on 18.03.2024.
//

import Foundation

protocol MainViewModelProtocol: AnyObject {
    func showAlert(with error: ErrorType)
    func assetsLoaded()
}

final class MainViewModel {
    
    //MARK: - Properties
    
    weak var vc: MainViewModelProtocol?
    
    var assets: [AssetIdentifier] = []
    var currentImage: ImageRepresentation?
    
    private let permissionChecker: PhotoLibraryPermissionChecking
    private let photoLibraryManager: PhotoLibraryManaging
    
    // MARK: - Init
    
    init(permissionChecker: PhotoLibraryPermissionChecking, photoLibraryManager: PhotoLibraryManaging) {
        self.permissionChecker = permissionChecker
        self.photoLibraryManager = photoLibraryManager
    }
    
    //MARK: - Methods

    func askPermissions() async {
        let status = await permissionChecker.checkPermission()
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
            let assets = try await photoLibraryManager.fetchAllImageAssets()
            let filteredAssets = assets.filter { asset in
                !GlobalVariables.processedPhotos.contains(asset.identifier) &&
                !GlobalVariables.photosInTrash.contains(asset.identifier)
            }
            
            self.assets = filteredAssets
            vc?.assetsLoaded()
        } catch {
            vc?.showAlert(with: .showError)
        }
    }
    
    func loadImage(with size: CGSize) async {
        do {
            guard let asset = assets.first else { 
                currentImage = nil
                return
            }
            let image = try await photoLibraryManager.fetchImage(for: asset, size: size)
            currentImage = image
        } catch {
            vc?.showAlert(with: .errorIamgeLoading)
        }
    }
    
    func addImagetoTrash() {
        guard let asset = assets.first else { return }
        assets.removeFirst()
        GlobalVariables.photosInTrash.append(asset.identifier)
    }
    
    func saveImage() {
        guard let asset = assets.first else { return }
        assets.removeFirst()
        GlobalVariables.processedPhotos.append(asset.identifier)
    }
    
    func emptyTrash() async {
        do {
            let _ = try await photoLibraryManager.deletePhotos(with: GlobalVariables.photosInTrash)
            GlobalVariables.photosInTrash.removeAll()
        } catch {
            vc?.showAlert(with: .deletionError)
        }

    }
}
