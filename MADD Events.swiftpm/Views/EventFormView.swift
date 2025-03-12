import SwiftUI

struct EventFormView: View {
    @State var name: String
    @State var startDate: Date
    @State var endDate: Date?
    @State var location: String
    @State var note: String
    @State var attendees: [Attendee]
    @Binding var isPresented: Bool
    var onSubmit: ((String, Date, Date?, String, String, [Attendee]) -> Void)?
    
    @State private var hasEndDate: Bool = false
    @State private var selectedEndDate: Date = Date()
    @FocusState private var isFocused: Bool
    
    private var isComplete: Bool {
        !(name.isEmpty || location.isEmpty || note.isEmpty)
    }
    
    var body: some View {
        Form {
            Section() {
                TextField("Title", text: $name)
                    .focused($isFocused)
                    .onAppear {
                        isFocused = true
                    }
                TextField("Location", text: $location)
            }
            
            Section() {
                DatePicker("Starts", selection: $startDate, displayedComponents: .date)
                HStack {
                    Text("Ends")
                    Spacer()
                        .frame(maxWidth: .infinity)
                    if hasEndDate {
                        Button(action: { hasEndDate = false }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                        DatePicker("", selection: $selectedEndDate, in: startDate..., displayedComponents: .date)
                    } else {
                        Button("None", action: { hasEndDate = true })
                        Spacer()
                    }
                }
            }
            
            AttendeeListView(attendees: $attendees)
            
            Section() {
                TextEditor(text: $note)
                    .frame(height: 120)
            }
        }
        .navigationTitle("New Event")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel", role: .destructive) {
                    isPresented = false
                }
                .foregroundColor(.red)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    onSubmit?(name, startDate, hasEndDate ? selectedEndDate : nil, location, note, attendees)
                    isPresented = false
                }
                    .disabled(!isComplete)
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
    
    NavigationStack {
        EventFormView(
            name: "",
            startDate: Date(),
            location: "",
            note: "",
            attendees: [user],
            isPresented: .constant(true),
            onSubmit: { name, startDate, endDate, location, note, attendees in
                print("Submit: \(name), \(startDate), \(String(describing: endDate)), \(location), \(note), \(attendees)")
            }
        )
    }
}
