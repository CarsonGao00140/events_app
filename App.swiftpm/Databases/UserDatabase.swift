import Foundation

@MainActor
@Observable
final class UserDatabase {
    static let shared = UserDatabase()
    private init() {}
    
    private let profileDatabase = Database<Profile>.shared
    private var id: UUID = UUID()

    func write(_ profile: Profile) -> UUID {
        if !profileDatabase.update(by: id, profile) {
            id = profileDatabase.create(profile)
        }
        
        return id
    }

    func read() -> (UUID, Profile)? {
        guard let profile = profileDatabase.read(by: id) else { return nil }
        return (id, profile)
    }
}
