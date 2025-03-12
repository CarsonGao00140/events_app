import SwiftUI

struct ContentView: View {
    @State var user: Attendee? = nil
    @State var events = [
        Event(name: "Demo",
            startDate: Date(),
            endDate: nil,
            location: "Ottawa",
            note: "Some Describition...",
            attendees: [
                Attendee(
                    firstName: "User",
                    lastName: "1",
                    avatar: Image(systemName: "1.circle"),
                    isHost: true
                )
            ],
            isCancelled: false)
    ]
    
    var body: some View {
        TabView {
            Tab("Events", systemImage: "list.bullet") {
                EventsView(events: events)
            }
            Tab("Profile", systemImage: "person.crop.circle") {
                ProfileView(user: $user)
            }
            .badge(user == nil ? Text("!"): nil)
        }
    }
}
