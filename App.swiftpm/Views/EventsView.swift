import SwiftUI

struct EventsView: View {
    @State private var selected: Event = .placeholder
    @State private var isFormPresented = false
    @State private var onFormSubmit: ((Event) -> Void)?
    
    private let database = Database<Event>.shared
    
    private var events: (ongoing: [(UUID, Event)], expired: [(UUID, Event)], canceled: [(UUID, Event)]) {
        let startOfToday = Calendar.current.startOfDay(for: Date())
        
        let (ongoing, expired, canceled) = database.readAll().reduce(into: (
            ongoing: [(UUID, Event)](),
            expired: [(UUID, Event)](),
            canceled: [(UUID, Event)]()
        )){ acc, eventEntry in
            
        if eventEntry.value.isCanceled {
            acc.canceled.append(eventEntry)
        } else {
            let referenceDate = eventEntry.value.endDate ?? eventEntry.value.startDate
            if referenceDate >= startOfToday {
                acc.ongoing.append(eventEntry)
            } else {
                acc.expired.append(eventEntry)
            }
        }
    }
        
        return (
            ongoing: ongoing.sorted { $0.1.startDate < $1.1.startDate },
            expired: expired.sorted { $0.1.startDate < $1.1.startDate },
            canceled: canceled.sorted { $0.1.startDate < $1.1.startDate }
        )
    }
    
    private func cancelButton(for id: UUID, with event: Event, isCanceled: Bool) -> some View {
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
    
    private func deleteButton(for id: UUID) -> some View {
        Button(role: .destructive) {
            _ = database.delete(by: id)
        } label: { Label("Delete", systemImage: "trash") }
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
            Section {
                ForEach(events.ongoing, id: \.0) { (id, event) in
                    Button(action: {
                        selected = event
                        onFormSubmit = { newEvent in
                            _ = database.update(by: id, newEvent)
                        }
                        isFormPresented = true
                    }){
                        Text(event.name)
                    }
                    .foregroundColor(.primary)
                    .swipeActions(edge: .leading) {
                        cancelButton(for: id, with: event, isCanceled: false)
                    }
                    .swipeActions(edge: .trailing) { deleteButton(for: id) }
                }
            }
            
            Section {
                ForEach(events.expired, id: \.0) { (id, event) in
                    Button(action: {
                        selected = event
                        onFormSubmit = { newEvent in
                            _ = database.update(by: id, newEvent)
                        }
                        isFormPresented = true
                    }){
                        Text(event.name)
                    }
                    .foregroundColor(.primary)
                    .swipeActions(edge: .leading) {
                        cancelButton(for: id, with: event, isCanceled: false)
                    }
                    .swipeActions(edge: .trailing) { deleteButton(for: id) }
                }
            }
            Section {
                ForEach(events.canceled, id: \.0) { (id, event) in
                    Button(action: {
                        selected = event
                        onFormSubmit = { newEvent in
                            _ = database.update(by: id, newEvent)
                        }
                        isFormPresented = true
                    }){
                        Text(event.name)
                    }
                    .foregroundColor(.primary)
                    .swipeActions(edge: .leading) {
                        cancelButton(for: id, with: event, isCanceled: true)
                    }
                    .swipeActions(edge: .trailing) { deleteButton(for: id) }
                }
            }
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
