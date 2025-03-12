import SwiftUI

struct EventFormView: View {
    @Binding var user: Attendee?
    @Binding var isPresented: Bool
    @State var isAttendeeFormPresented = false
    @State var attendees: [Attendee] = []
    @State var name: String = ""
    @State var location: String = ""
    @State var notes: String = ""
    @State var startDate = Date()
    
    let user1 = Attendee(
        firstName: "User 1",
        lastName: "",
        avatar: Image(systemName: "person.circle"),
        isHost: true
    )
    
    let user2 = Attendee(
        firstName: "User 2",
        lastName: "",
        avatar: Image(systemName: "person.circle"),
        isHost: false
    )
    
    private func edit() {
        isAttendeeFormPresented = true
    }
    
    private func toggleHost(_ attendee: Attendee) {
        if let index = attendees.firstIndex(where: { $0.id == attendee.id }) {
            attendees[index].isHost.toggle()
        }
    }
    
    private func remove(_ attendee: Attendee) {
        if let index = attendees.firstIndex(where: { $0.id == attendee.id }) {
            attendees.remove(at: index)
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section() {
                    TextField("Title", text: $name)
                    TextField("Location", text: $location)
                }
                Section() {
                    DatePicker("Starts", selection: $startDate, displayedComponents: .date)
                    DatePicker("Ends", selection: $startDate, in: startDate..., displayedComponents: .date)
                }
                Section {
                    ForEach(attendees.filter { $0.isHost }) { attendee in
                        let hasMultipleHosts = attendees.filter({ $0.isHost }).count > 1
                        Text(attendee.firstName)
                            .onTapGesture(perform: edit)
                            .swipeActions(edge: .leading) {
                                if hasMultipleHosts {
                                    Button {
                                        toggleHost(attendee)
                                    } label: {
                                        Label("Remove from Host", systemImage: "person.slash.fill")
                                    }
                                    .tint(.blue)
                                }
                            }
                            .swipeActions(edge: .trailing) {
                                if hasMultipleHosts {
                                    Button(role: .destructive) {
                                        remove(attendee)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    
                                }
                            }
                    }
                }
                Section {
                    ForEach(attendees.filter { !$0.isHost }) { attendee in
                        Text(attendee.firstName)
                            .onTapGesture(perform: edit)
                            .swipeActions(edge: .leading) {
                                Button {
                                    toggleHost(attendee)
                                } label: {
                                    Label("Set as Host", systemImage: "person.fill")
                                }
                                .tint(.blue)
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    remove(attendee)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }
                Section() {
                    TextEditor(text: $notes)
                        .frame(height: 120)
                }
            }
            .navigationTitle("New Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {}
                }
            }
            .sheet(isPresented: $isAttendeeFormPresented) {
                NavigationView {
                    AttendeeFormView(
                        onChange: { firstName, lastName, avatar in
                            print("First Name:", firstName, "Last Name:", lastName, "Avatar:", String(describing: avatar))
                        },
                        clear: .constant({}),
                        isPresented: $isAttendeeFormPresented
                    )
               }
            }
        }
        .onAppear {
            attendees = [user1, user2]
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
