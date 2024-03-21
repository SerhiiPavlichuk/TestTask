//
//  PhotoLibraryPermissionChecker.swift
//  TestTask
//
//  Created by User on 20.03.2024.
//


import Photos

protocol PhotoLibraryPermissionChecking {
    func checkPermission() async -> PHAuthorizationStatus
}

final class PhotoLibraryPermissionChecker: PhotoLibraryPermissionChecking {
    func checkPermission() async -> PHAuthorizationStatus {
        return await withCheckedContinuation { continuation in
            let status = PHPhotoLibrary.authorizationStatus()
            if status == .notDetermined {
                PHPhotoLibrary.requestAuthorization { newStatus in
                    continuation.resume(returning: newStatus)
                }
            } else {
                continuation.resume(returning: status)
            }
        }
    }
}
