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
    
    private enum Constants {
        static let mediaType = "mediaType = %d"
        static let creatinDate = "creationDate"
        static let domain = "PhotoLibraryManager"
        static let errorDecription = "Failed to convert UIImage to Data"
    }
    
    func fetchAllImageAssets() async throws -> [AssetIdentifier] {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: Constants.mediaType, PHAssetMediaType.image.rawValue)
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: Constants.creatinDate, ascending: false)]
        
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
        
        let options = PHImageRequestOptions()
        options.version = .current
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        options.isNetworkAccessAllowed = true

        return try await withCheckedThrowingContinuation { continuation in
            PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: options) { image, _ in
                guard let image = image, let data = image.pngData() else {
                    continuation.resume(throwing: NSError(domain: Constants.domain, code: 0, userInfo: [NSLocalizedDescriptionKey: Constants.errorDecription]))
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
