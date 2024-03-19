//
//  PhotoManager.swift
//  TestTask
//
//  Created by User on 18.03.2024.
//

import UIKit
import Photos

final class PhotoManager {
    static let shared = PhotoManager()
    
    private init () {}
    
    func checkPermission() async -> PHAuthorizationStatus {
        return await withCheckedContinuation { continuation in
            let status = PHPhotoLibrary.authorizationStatus()
            if status == .notDetermined {
                PHPhotoLibrary.requestAuthorization { newStatus in
                    DispatchQueue.main.async {
                        continuation.resume(returning: newStatus)
                    }
                }
            } else {
                continuation.resume(returning: status)
            }
        }
    }
    
    func fetchAllImageAssets() async throws -> [PHAsset] {
        return try await withCheckedThrowingContinuation { continuation in
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            let result = PHAsset.fetchAssets(with: fetchOptions)
            var assets = [PHAsset]()
            result.enumerateObjects { asset, _, _ in
                assets.append(asset)
            }
            continuation.resume(returning: assets)
        }
    }
    
    func fetchImage(for asset: PHAsset, size: CGSize) async throws -> UIImage? {
        return try await withCheckedThrowingContinuation { continuation in
            let manager = PHImageManager.default()
            let options = PHImageRequestOptions()
            options.version = .current
            options.isSynchronous = false
            options.deliveryMode = .highQualityFormat
            options.resizeMode = .exact
            
            manager.requestImage(for: asset,
                                 targetSize: size,
                                 contentMode: .aspectFill,
                                 options: options) { image, _ in
                continuation.resume(returning: image)
            }
        }
    }
    
    func deletePhotos(with identifiers: [String]) async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            PHPhotoLibrary.shared().performChanges {
                let assetsToDelete = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
                PHAssetChangeRequest.deleteAssets(assetsToDelete)
            } completionHandler: { success, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: success)
                }
            }
        }
    }
}
