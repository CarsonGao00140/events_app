import Foundation

@MainActor
@Observable
class OthersDatabase {
    static let shared = OthersDatabase()
    private init() {}
    
    private var storage = [UUID: Profile]()
    
    func create(_ profile: Profile) -> UUID {
        let id = UUID()
        storage[id] = profile
        return id
    }
    
    func readAll() -> [(UUID, Profile)] {
        Array(storage)
    }
    
    func update(by id: UUID, _ profile: Profile) -> Bool {
        guard storage[id] != nil else { return false }
        storage[id] = profile
        return true
    }
    
    func delete(by id: UUID) -> Bool {
        storage.removeValue(forKey: id) != nil
    }
}
