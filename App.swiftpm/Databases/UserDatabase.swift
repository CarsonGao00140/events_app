import Foundation

@MainActor
@Observable
class UserDatabase {
    static let shared = UserDatabase()
    private var user: Profile? = nil
    
    func read() -> Profile? { user }
    
    func update(_ profile: Profile) { user = profile }
    
    func delete() { user = nil }
}
