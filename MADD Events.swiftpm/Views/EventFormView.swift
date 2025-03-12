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
    
    @State private var selectedAttendee: Attendee?
    @State private var isAttendeeFormPresented = false
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var avatar = Image(systemName: "person.circle")
    
    let user1 = Attendee(
        firstName: "User",
        lastName: "1",
        avatar: Image(systemName: "1.circle"),
        isHost: true
    )
    
    let user2 = Attendee(
        firstName: "User",
        lastName: "2",
        avatar: Image(systemName: "2.circle"),
        isHost: false
    )
    
    private func edit(attendee: Attendee) {
        selectedAttendee = attendee
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
                    DatePicker("Ends", selection: $endDate, in: startDate..., displayedComponents: .date)
                }
                Section {
                    ForEach(attendees.filter { $0.isHost }) { attendee in
                        let hasMultipleHosts = attendees.filter({ $0.isHost }).count > 1
                        Text("\(attendee.firstName) \(attendee.lastName)")
                            .onTapGesture {
                                edit(attendee: attendee)
                            }
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
                        Text("\(attendee.firstName) \(attendee.lastName)")
                            .onTapGesture {
                                edit(attendee: attendee)
                            }
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
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {}
                }
            }
            .sheet(isPresented: $isAttendeeFormPresented) {
                if let selectedAttendee = selectedAttendee {
                    AttendeeFormView(
                        firstName: $firstName,
                        lastName: $lastName,
                        avatar: $avatar,
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
