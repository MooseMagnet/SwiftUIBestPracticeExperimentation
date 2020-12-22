
import Foundation

protocol PersistenceService {
    
    func save<T: Codable>(_ t: T)
    
    func load<T: Codable>() -> T?
}

class UserDefaultsPersistenceService : PersistenceService {
    
    func save<T: Codable>(_ t: T) {
        UserDefaults.standard.setValue(try! JSONEncoder().encode(t), forKey: "\(T.self)")
    }
    
    func load<T: Codable>() -> T? {
        guard let stored = UserDefaults.standard.string(forKey: "\(T.self)") else {
            return nil
        }
        return try! JSONDecoder().decode(T.self, from: stored.data(using: .utf8)!)
    }
}
