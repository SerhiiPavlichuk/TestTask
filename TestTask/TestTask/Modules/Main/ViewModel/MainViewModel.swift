//
//  MainViewModel.swift
//  TestTask
//
//  Created by User on 18.03.2024.
//

import Foundation

protocol MainViewModelProtocol: AnyObject {
    func showPermissionsAlert()
}

final class MainViewModel {
    
    //MARK: - Properties
    
    weak var vc: MainViewModelProtocol?
    

    // MARK: - Init

    func askPermissions() async {
        let status = await PhotoManager.shared.checkPermission()
        if status == .authorized {
            #warning("get fetch")
        } else if status == .denied {
            DispatchQueue.main.async { [weak self] in
                self?.vc?.showPermissionsAlert()
            }
        }
    }
}
