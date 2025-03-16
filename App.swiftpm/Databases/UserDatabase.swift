import Foundation

@MainActor
@Observable
class UserDatabase {
    static let shared = UserDatabase()
    private init() {}
    
    private var user: Profile? = nil
    
    func write(_ profile: Profile) { user = profile }
    
    func read() -> Profile? { user }
    
    func delete() -> Bool {
        guard user != nil else { return false }
        user = nil
        return true
    }
}
