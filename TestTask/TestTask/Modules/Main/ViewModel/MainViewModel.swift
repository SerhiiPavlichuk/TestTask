//
//  MainViewModel.swift
//  TestTask
//
//  Created by User on 18.03.2024.
//

import Foundation
import Photos

protocol MainViewModelProtocol: AnyObject {
    func showPermissionsAlert()
    func showErrorAlert()
}

final class MainViewModel {
    
    //MARK: - Properties
    
    weak var vc: MainViewModelProtocol?
    
    var assets: [PHAsset] = []
    
    // MARK: - Init

    func askPermissions() async {
        let status = await PhotoManager.shared.checkPermission()
        if status == .authorized {
            await getAllImageAssets()
        } else if status == .denied {
            DispatchQueue.main.async { [weak self] in
                self?.vc?.showPermissionsAlert()
            }
        }
    }
    
    func getAllImageAssets() async {
        do {
            let assets = try await PhotoManager.shared.fetchAllImageAssets()
        } catch {
            vc?.showErrorAlert()
        }
    }
}
