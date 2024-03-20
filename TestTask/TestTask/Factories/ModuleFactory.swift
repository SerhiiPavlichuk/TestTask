//
//  ModuleFactory.swift
//  TestTask
//
//  Created by User on 18.03.2024.
//

import UIKit

final class ModuleFactory {
    
    enum ModuleType {
        case main
    }
    
    func createModule(type: ModuleType) -> UIViewController {
        switch type {
        case .main:
            let viewModel = MainViewModel(permissionChecker: PhotoLibraryPermissionChecker(), photoLibraryManager: PhotoLibraryManager())
            return MainViewController(viewModel: viewModel)

        }
    }
    
}
