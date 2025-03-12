import SwiftUI 

struct Attendee: Identifiable, Equatable {
    let id = UUID()
    let firstName: String
    let lastName: String
    let avatar: Image?
    var isHost: Bool
 }
