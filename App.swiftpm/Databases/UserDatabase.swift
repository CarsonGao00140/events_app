import Foundation

@Observable
class UserDatabase {
    static let shared = UserDatabase()
    
    private(set) var user: Profile? = nil
    
    func set(_ profile: Profile) {
        user = profile
    }
    
    func delete() {
        user = nil
    }
}
