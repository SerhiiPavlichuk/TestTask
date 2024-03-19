import Foundation

struct GlobalVariables {
    enum UserDefaultKeys: String {
        case processedPhotos = "processedPhotos"
        case photosInTrash = "photosInTrash"
    }

    static var processedPhotos: [String] {
        get {
            let array = UserDefaults.standard.array(forKey: UserDefaultKeys.processedPhotos.rawValue) as? [String] ?? []
            return array
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.processedPhotos.rawValue)
        }
    }
    
    static var photosInTrash: [String] {
        get {
            let array = UserDefaults.standard.array(forKey: UserDefaultKeys.photosInTrash.rawValue) as? [String] ?? []
            return array
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.photosInTrash.rawValue)
        }
    }
}
