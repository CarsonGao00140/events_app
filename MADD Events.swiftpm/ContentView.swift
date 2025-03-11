import SwiftUI

struct Event: Identifiable {
    let id = UUID()
    let name: String
    let date: Date
}

struct ContentView: View {
    let events: [Event] = [
        Event(name: "已举办活动1", date: Date().addingTimeInterval(-86400)),
        Event(name: "已举办活动2", date: Date().addingTimeInterval(-172800)),
        Event(name: "未举办活动1", date: Date().addingTimeInterval(86400)),
        Event(name: "未举办活动2", date: Date().addingTimeInterval(172800))
    ]
    
    var pastEvents: [Event] {
        events.filter { $0.date < Date() }
    }
    
    var upcomingEvents: [Event] {
        events.filter { $0.date >= Date() }
    }
    
    var body: some View {
        TabView {
            Tab("Events", systemImage: "party.popper") {
                ProfileView()
            }
            Tab("Profile", systemImage: "person.crop.circle") {
                ProfileView()
            }
        }
    }
}
