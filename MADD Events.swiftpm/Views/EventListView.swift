import SwiftUI

struct EventListView: View {
    @Binding var events: [Event]
    
    @State private var selectedEvent: Event?
    @State private var isEventFormPresented = false
    
    private func add(name: String, startDate: Date, endDate: Date?, location: String, note: String, attendees: [Attendee]) {
        let event = Event(
            name: name,
            startDate: startDate,
            endDate: endDate,
            location: location,
            note: note,
            attendees: attendees,
            isCancelled: false
        )
        events.append(event)
        
    }
    
    private func edit(event: Event) {
        selectedEvent = event
        isEventFormPresented = true
        print(selectedEvent as Any)
    }
    
    private func remove(_ event: Event) {
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events.remove(at: index)
        }
    }
    
    var body: some View {
        Group {
            Section() {
                Button("New Event", action: {
                    isEventFormPresented = true
                })
                ForEach(events) { event in
                    /*@START_MENU_TOKEN@*/Text(event.name)/*@END_MENU_TOKEN@*/
                        .onTapGesture {
                            edit(event: event)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                remove(event)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
        }
        .sheet(isPresented: $isEventFormPresented) {
            NavigationView {
                if let index = events.firstIndex(where: { $0.id == selectedEvent?.id }) {
                    EventFormView(
                        name: events[index].name,
                        startDate: events[index].startDate,
                        endDate: events[index].endDate,
                        location: events[index].location,
                        note: events[index].note,
                        attendees: events[index].attendees,
                        isPresented: $isEventFormPresented,
                        onSubmit: { name, startDate, endDate, location, note, attendees in
                            events[index] = Event(
                                name: name,
                                startDate: startDate,
                                endDate: endDate,
                                location: location,
                                note: note,
                                attendees: attendees,
                                isCancelled: events[index].isCancelled
                            )
                        }
                    )
                } else {
                    EventFormView(
                        name: "",startDate: Date(),
                        location: "",
                        note: "",
                        attendees: [],
                        isPresented: $isEventFormPresented,
                        onSubmit: { name, startDate, endDate, location, note, attendees in
                            let event = Event(
                                name: name,
                                startDate: startDate,
                                endDate: endDate,
                                location: location,
                                note: note,
                                attendees: attendees,
                                isCancelled: false
                            )
                            events.append(event)
                        }
                    )
                }
                    
            }
            .onDisappear {
                selectedEvent = nil
            }
        }
    }
}

#Preview {
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
    
    Form {
        EventListView(events: $events)
    }
}
