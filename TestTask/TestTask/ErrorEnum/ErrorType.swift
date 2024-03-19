//
//  ErrorType.swift
//  TestTask
//
//  Created by User on 19.03.2024.
//

import Foundation

enum ErrorType: Error {
    case donthavePermission
    case showError
    case errorIamgeLoading
    case deletionError
    
    var title: String {
        switch self {
        case .donthavePermission:
            return "Oops, we can't load photos"
        case .showError:
            return "Oops, error"
        case .errorIamgeLoading:
            return "Image loading error"
        case .deletionError:
            return "Deletion Error"
        }
    }
    
    var message: String {
        switch self {
        case .donthavePermission:
            return "Please give acces to library in settings"
        case .showError:
            return "Error when try fetch photos"
        case .errorIamgeLoading:
            return "Please try again"
        case .deletionError:
            return "Failed to delete photos"
        }
    }
}
