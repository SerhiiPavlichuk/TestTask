//
//  PhotoLibraryManager.swift
//  TestTask
//
//  Created by User on 20.03.2024.
//

import UIKit
import Photos

protocol PhotoLibraryManaging {
    func fetchAllImageAssets() async throws -> [AssetIdentifier]
    func fetchImage(for identifier: AssetIdentifier, size: CGSize) async throws -> ImageRepresentation?
    func deletePhotos(with identifiers: [String]) async throws -> Bool
}

final class PhotoLibraryManager: PhotoLibraryManaging {
    func fetchAllImageAssets() async throws -> [AssetIdentifier] {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let result = PHAsset.fetchAssets(with: fetchOptions)
        var assetIdentifiers: [AssetIdentifier] = []
        result.enumerateObjects { (asset, _, _) in
            assetIdentifiers.append(AssetIdentifier(identifier: asset.localIdentifier))
        }
        return assetIdentifiers
    }
    
    func fetchImage(for identifier: AssetIdentifier, size: CGSize) async throws -> ImageRepresentation? {
        guard let asset = PHAsset.fetchAssets(withLocalIdentifiers: [identifier.identifier], options: nil).firstObject else {
            return nil
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            let options = PHImageRequestOptions()
            options.version = .current
            options.isSynchronous = false
            options.deliveryMode = .highQualityFormat
            options.resizeMode = .exact
            
            PHImageManager.default().requestImageData(for: asset, options: options) { (data, _, _, _) in
                guard let data = data else {
                    continuation.resume(returning: nil)
                    return
                }
                continuation.resume(returning: ImageRepresentation(data: data))
            }
        }
    }
    
    func deletePhotos(with identifiers: [String]) async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            PHPhotoLibrary.shared().performChanges({
                let assetsToDelete = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
                PHAssetChangeRequest.deleteAssets(assetsToDelete)
            }) { success, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: success)
                }
            }
        }
    }
}
