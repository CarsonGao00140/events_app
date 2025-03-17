import Foundation

struct Event: Equatable {
    let name: String
    let location: String
    let startDate: Date
    let endDate: Date?
    let hostAttendees: [UUID]
    let otherAttendees: [UUID]
    let note: String
    let isCanceled: Bool
    
    static func isValid(_ event: Event) -> Bool {
        !event.name.isEmpty &&
        !event.location.isEmpty &&
        !event.hostAttendees.isEmpty &&
        !event.note.isEmpty &&
        event.endDate.map { $0 > event.startDate } ?? true
    }
    
    init(
        name: String,
        location: String,
        startDate: Date,
        endDate: Date? = nil,
        hostAttendees: [UUID],
        otherAttendees: [UUID] = [],
        note: String,
        isCanceled: Bool = false
    ) {
        self.name = name
        self.location = location
        self.startDate = startDate
        self.endDate = endDate
        self.hostAttendees = hostAttendees
        self.otherAttendees = otherAttendees
        self.note = note
        self.isCanceled = isCanceled
    }
    
    @MainActor
    static var placeholder: Self {
        let id = UserDatabase.shared.read()?.0
        return .init(
            name: "",
            location: "",
            startDate: Date(),
            endDate: nil,
            hostAttendees: id.map { [$0] } ?? [],
            otherAttendees: [],
            note: ""
        )
    }
}
