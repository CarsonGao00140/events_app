import Foundation

struct Event {
    let name: String
    let startDate: Date
    let endDate: Date?
    let location: String
    let note: String
    var attendees: [Attendee]
    var isCancelled: Bool
}
