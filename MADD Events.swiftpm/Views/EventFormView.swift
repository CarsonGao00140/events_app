import SwiftUI

struct EventFormView: View {
    @Binding var user: Attendee?
    @Binding var isPresented: Bool
    
    @State private var attendees: [Attendee] = []
    @State private var name: String = ""
    @State private var location: String = ""
    @State private var notes: String = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section() {
                    TextField("Title", text: $name)
                    TextField("Location", text: $location)
                }
                Section() {
                    DatePicker("Starts", selection: $startDate, displayedComponents: .date)
                    DatePicker("Ends", selection: $endDate, in: startDate..., displayedComponents: .date)
                }
                AttendeeListView(attendees: $attendees)
                Section() {
                    TextEditor(text: $notes)
                        .frame(height: 120)
                }
            }
            .navigationTitle("New Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {}
                }
            }
            .onAppear {
                if let user = user {
                    attendees = [user]
                }
            }
        }
    }
}
#Preview{
    let user = Attendee(
        firstName: "Carson",
        lastName: "Gao",
        avatar: Image(systemName: "person.crop.circle.dashed"),
        isHost: true
    )
        
    EventFormView(user: .constant(user), isPresented: .constant(true))
}
