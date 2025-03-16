import Foundation

@MainActor
@Observable
class OthersDatabase {
    static let shared = OthersDatabase()
    private var others: [Profile] = []
    
    func create(_ profile: Profile) {
        others.append(profile)
    }
    
    func read(by id: UUID) -> Profile? {
        others.first { $0.id == id }
    }
    
    func readAll() -> [Profile] { others }
    
    func update(by id: UUID, _ profile: Profile) -> Bool {
        if let index = others.firstIndex(where: { $0.id == id }) {
            others[index] = profile
            return true
        }
        return false
    }

    func deleteAttendee(by id: UUID) -> Bool {
        if let index = others.firstIndex(where: { $0.id == id }) {
            others.remove(at: index)
            return true
        }
        return false
    }
}
