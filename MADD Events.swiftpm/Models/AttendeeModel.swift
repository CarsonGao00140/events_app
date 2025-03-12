import SwiftUI 

struct Attendee: Identifiable {
    let id = UUID()
    let firstName: String
    let lastName: String
    let avatar: Image?
    var isHost: Bool
 }
