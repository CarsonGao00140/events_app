import Foundation

@MainActor
@Observable
class Database<T> {
    private init() {}
    
    private var storage = [UUID: T]()
    
    func create(_ value: T) -> UUID {
        let id = UUID()
        storage[id] = value
        return id
    }
    
    func read(by id: UUID) -> T? {
        storage[id]
    }
    
    func readAll() -> [UUID: T] {
        return storage
    }
    
    func update(by id: UUID, _ value: T) -> Bool {
        guard storage[id] != nil else { return false }
        storage[id] = value
        return true
    }
    
    func delete(by id: UUID) -> Bool {
        storage.removeValue(forKey: id) != nil
    }
}

extension Database where T == Event {
    static let shared = Database<Event>()
}

extension Database where T == Profile {
    static let shared = Database<Profile>()
}
