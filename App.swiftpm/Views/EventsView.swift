import SwiftUI

struct EventsView: View {
    @State private var selected: Event = .placeholder
    @State private var isFormPresented = false
    @State private var onFormSubmit: ((Event) -> Void)?
    
    @State private var selectedSegment = 0
    
    private let database = Database<Event>.shared
    
    private var events: (upcoming: [(UUID, Event)], expired: [(UUID, Event)], canceled: [(UUID, Event)]) {
        let startOfToday = Calendar.current.startOfDay(for: Date())
        
        let (ongoing, expired, canceled) = database.readAll().reduce(into: (
            upcoming: [(UUID, Event)](),
            expired: [(UUID, Event)](),
            canceled: [(UUID, Event)]()
        )){ acc, eventEntry in

            if eventEntry.value.isCanceled {
                acc.canceled.append(eventEntry)
            } else {
                let referenceDate = eventEntry.value.endDate ?? eventEntry.value.startDate
                if referenceDate >= startOfToday {
                    acc.upcoming.append(eventEntry)
                } else {
                    acc.expired.append(eventEntry)
                }
            }
        }
        
        return (
            upcoming: ongoing.sorted { $0.1.startDate < $1.1.startDate },
            expired: expired.sorted { $0.1.startDate < $1.1.startDate },
            canceled: canceled.sorted { $0.1.startDate < $1.1.startDate }
        )
    }
    
    @ViewBuilder
    private func eventSection(title: String, events: [(UUID, Event)], isCanceled: Bool) -> some View {
        if !events.isEmpty {
            Section(title) {
                ForEach(events, id: \.0) { (id, event) in
                    Button(action: {
                        selected = event
                        onFormSubmit = { newEvent in
                            _ = database.update(by: id, newEvent)
                        }
                        isFormPresented = true
                    }){ EventRow(event) }
                        .foregroundColor(.primary)
                        .swipeActions(edge: .leading) {
                            Button() {
                                let newEvent = Event(
                                    name: event.name,
                                    location: event.location,
                                    startDate: event.startDate,
                                    endDate: event.endDate,
                                    hostAttendees: event.hostAttendees,
                                    otherAttendees: event.otherAttendees,
                                    note: event.note,
                                    isCanceled: !isCanceled
                                )
                                _ = database.update(by: id, newEvent)
                            } label: {
                                isCanceled
                                ? Label("Cancel", systemImage: "tray.and.arrow.up.fill")
                                : Label("Undo Cancel", systemImage: "tray.and.arrow.down.fill")
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                _ = database.delete(by: id)
                            } label: { Label("Delete", systemImage: "trash") }
                        }
                }
            }
        }
    }
    
    var body: some View {
        List {
            Section {
                Button("Create Event") {
                    onFormSubmit = { newEvent in
                        _ = database.create(newEvent)
                    }
                    isFormPresented = true
                }
            }
            eventSection(title: "Upcoming", events: events.upcoming, isCanceled: false)
            eventSection(title: "Expired", events: events.expired, isCanceled: false)
            eventSection(title: "Canceled", events: events.canceled, isCanceled: true)
        }
        .sheet(isPresented: $isFormPresented, onDismiss: {
            selected = .placeholder
        }) {
            EventFormView(
                isPresented: $isFormPresented,
                event: selected,
                onSubmit: { newProfile in onFormSubmit?(newProfile) }
            )
        }
    }
}

#Preview {
    EventsView()
}
