import SwiftUI

struct EventFormView: View {
    @Binding var isPresented: Bool
    @State private var name: String
    @State private var location: String
    @State private var startDate: Date
    @State private var endDate: Date?
    @State private var hostAttendees: [UUID]
    @State private var otherAttendees: [UUID]
    @State private var note: String
    
    private let event: Event
    private var submit: (Event) -> Void
    
    init(isPresented: Binding<Bool>, event: Event, onSubmit: @escaping (Event) -> Void) {
        self._isPresented = isPresented
        self.event = event
        _name = State(wrappedValue: event.name)
        _location = State(wrappedValue: event.location)
        _startDate = State(wrappedValue: event.startDate)
        _endDate = State(wrappedValue: event.endDate)
        _hostAttendees = State(wrappedValue: event.hostAttendees)
        _otherAttendees = State(wrappedValue: event.otherAttendees)
        _note = State(wrappedValue: event.note)
        submit = onSubmit
    }
    
    private var isValid: Bool { Event.isValid(newEvent) && newEvent != event }
    
    private var newEvent: Event {
        .init(
            name: name,
            location: location,
            startDate: startDate,
            endDate: endDate,
            hostAttendees: hostAttendees,
            otherAttendees: otherAttendees,
            note: note
        )
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                    TextField("Location", text: $location)
                }
                
                Section {
                    DatePickers(start: $startDate, end: $endDate)
                }
                
                AttendeeSections(hostAttendees: $hostAttendees, otherAttendees: $otherAttendees)
                
                Section {
                    TextEditor(text: $note).frame(height: 120)
                }
            }
            .navigationTitle("Edit Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", role: .cancel) { isPresented = false }
                    .foregroundColor(.red)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        submit(newEvent)
                        isPresented = false
                    }
                    .disabled(!isValid)
                }
            }
        }
    }
}

#Preview {
    EventFormView(isPresented: .constant(true), event: .placeholder) { newEvent in
        print(newEvent)
    }
}
