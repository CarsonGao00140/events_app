import SwiftUI

struct AttendeeListView: View {
    @Binding var attendees: [Attendee]
    
    @State private var clearForm: (() -> Void)?
    @State private var selectedAttendee: Attendee?
    @State private var isAttendeeFormPresented = false
    
    private func add(firstName: String, lastName: String, avatar: Image) {
        let newAttendee = Attendee(
            firstName: firstName,
            lastName: lastName,
            avatar: avatar,
            isHost: false)
        attendees.append(newAttendee)
    }
    
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
    
    var hosts: [Attendee] {
        attendees.filter { $0.isHost }
    }

    var nonHosts: [Attendee] {
        attendees.filter { !$0.isHost }
    }
    
    var body: some View {
        Group {
            Section() {
                ForEach(hosts) { attendee in
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
            Section() {
                Button("New Attendee", action: {
                    isAttendeeFormPresented = true
                })
                ForEach(nonHosts) { attendee in
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
        }
        .sheet(isPresented: $isAttendeeFormPresented) {
            NavigationView {
                if let index = attendees.firstIndex(where: { $0.id == selectedAttendee?.id }) {
                    AttendeeFormView(
                        firstName: attendees[index].firstName,
                        lastName: attendees[index].lastName,
                        avatar: attendees[index].avatar,
                        clear: $clearForm,
                        isPresented: $isAttendeeFormPresented,
                        onSubmit: { firstName, lastName, avatar in
                            attendees[index] = Attendee(
                                firstName: firstName,
                                lastName: lastName,
                                avatar: avatar,
                                isHost: attendees[index].isHost)
                        }
                    )
                } else {
                    AttendeeFormView(
                        firstName: "",
                        lastName: "",
                        clear: .constant(nil),
                        isPresented: $isAttendeeFormPresented,
                        onSubmit: { firstName, lastName, avatar in
                            let newAttendee = Attendee(
                                firstName: firstName,
                                lastName: lastName,
                                avatar: avatar,
                                isHost: false)
                            attendees.append(newAttendee)
                        }
                    )
                }
            }
            .onDisappear {
                selectedAttendee = nil
            }
        }
    }
}

#Preview{
    @Previewable @State var attendees: [Attendee] = [
        Attendee(
            firstName: "User",
            lastName: "1",
            avatar: Image(systemName: "1.circle"),
            isHost: true
        ),
        Attendee(
            firstName: "User",
            lastName: "2",
            avatar: Image(systemName: "2.circle"),
            isHost: false
        )
    ]
    
    Form {
        AttendeeListView(attendees: $attendees)
    }
}
