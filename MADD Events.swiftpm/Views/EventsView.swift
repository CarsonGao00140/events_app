import SwiftUI

struct EventsView: View {
    @State var user: Attendee?
    @State var events: [Event]
    @State var isEventFormPresented = false
    
    var body: some View {
        NavigationStack {
            Form {
                EventListView(events: $events)
            }
            .navigationTitle("Events")
            .padding()
        }
    }
}

#Preview{
    @Previewable @State var user = Attendee(
        firstName: "User",
        lastName: "1",
        avatar: Image(systemName: "1.circle"),
        isHost: true
    )
    @Previewable @State var events = [
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
        
    EventsView(user: user, events: events)
}
