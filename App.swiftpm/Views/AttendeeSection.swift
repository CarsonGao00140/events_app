import SwiftUI

struct AttendeeSections: View {
    @Binding var hostAttendees: [UUID]
    @Binding var otherAttendees: [UUID]
    
    private let profileDatabase = Database<Profile>.shared
    
    private var unassignedProfiles: [(UUID, Profile)] {
        let profiles = profileDatabase.readAll()
        let assigned = Set(hostAttendees + otherAttendees)
        return profiles
            .filter { !assigned.contains($0.0) }
            .sorted(by: { $0.0 < $1.0 })
    }

    struct AttendeeSection: View {
        @Binding var attendees: [UUID]
        @Binding var destinationAttendees: [UUID]
        @State private var selected: UUID?
        var label: String
        var moveButtonLabel: Label<Text, Image>
        var profiles: [(UUID, Profile)]
        var readProfile: (UUID) -> Profile?
        var disableSwipe: Bool = false
        
        var body: some View {
            Section {
                Picker(
                    selection: $selected,
                    label: Text(label).foregroundColor(.blue)
                ) {
                    Text("Select a Profile").tag(UUID?.none)
                    ForEach(profiles, id: \.0) { (id, profile) in
                        Text("\(profile.firstName) \(profile.lastName)").tag(id)
                            .tint(.blue)
                    }
                }
                .disabled(profiles.isEmpty)
                .onChange(of: selected) {
                    if let id = selected {
                        attendees.append(id)
                    }
                    selected = nil
                }
                ForEach(attendees, id: \.self) { id in
                    Group {
                        if let profile = readProfile(id) {
                            Text("\(profile.firstName) \(profile.lastName)")
                        } else {
                            Text("Deleted").foregroundColor(.gray)
                        }
                    }
                    .swipeActions(edge: .leading) {
                        if !disableSwipe {
                            Button {
                                if let index = attendees.firstIndex(where: { $0 == id }) {
                                    let id = attendees.remove(at: index)
                                    destinationAttendees.append(id)
                                }
                            } label: { moveButtonLabel }
                            .tint(.blue)
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        if !disableSwipe {
                            Button(role: .destructive) {
                                attendees.removeAll { $0 == id }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
        }
    }
    
    var body: some View {
        AttendeeSection(
            attendees: $hostAttendees,
            destinationAttendees: $otherAttendees,
            label: "Add Host",
            moveButtonLabel: Label("Move to Other", systemImage: "person.slash.fill"),
            profiles: unassignedProfiles,
            readProfile: { id in profileDatabase.read(by: id) },
            disableSwipe: hostAttendees.count == 1
        )
        AttendeeSection(
            attendees: $otherAttendees,
            destinationAttendees: $hostAttendees,
            label: "Add Other",
            moveButtonLabel: Label("Move to Host", systemImage: "person.fill"),
            profiles: unassignedProfiles,
            readProfile: { id in profileDatabase.read(by: id) }
        )
    }
}

#Preview {
    @Previewable @State var hostAttendees: [UUID] = []
    @Previewable @State var otherAttendees: [UUID] = []
    
    Form {
        AttendeeSections(
            hostAttendees: $hostAttendees, otherAttendees: $otherAttendees
        )
    }
}
