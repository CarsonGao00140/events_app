import SwiftUI

struct AttendeeSections: View {
    @Binding var hostAttendees: [UUID]
    @Binding var otherAttendees: [UUID]
    
    private let profileDatabase = Database<Profile>.shared
    
    private var unassignedProfiles: [(UUID, Profile)] {
        let profiles = profileDatabase.readAll()
        let assigned = Set(hostAttendees + otherAttendees)
        return profiles
            .filter { !assigned.contains($0.key) }
            .sorted(by: { $0.value.lastName < $1.value.lastName })
    }

    struct AttendeeSection: View {
        @Binding var attendees: [UUID]
        @Binding var destinationAttendees: [UUID]
        @State private var selected: UUID?
        let label: String
        let moveButtonLabel: Label<Text, Image>
        let profiles: [(UUID, Profile)]
        let readProfile: (UUID) -> Profile?
        
        var body: some View {
            Section {
                Picker(
                    selection: $selected,
                    label: Text(label).foregroundColor(.blue)
                ) {
                    Text("Select a Profile").tag(UUID?.none)
                    ForEach(profiles, id: \.0) { (id, profile) in
                        Text("\(profile.firstName) \(profile.lastName)").tag(id)
                    }
                }
                .disabled(profiles.isEmpty)
                .onChange(of: selected) {
                    if let id = selected { attendees.append(id) }
                    selected = nil
                }
                
                ForEach(attendees, id: \.self) { id in
                    Group {
                        if let profile = readProfile(id) {
                            ProfileRow(profile)
                        } else {
                            ProfileRow(
                                Profile(
                                    firstName: "Deleted",
                                    lastName: "[\(id.uuidString.prefix(4))]",
                                    avatarData: nil
                                )
                            )
                            .foregroundColor(.gray)
                        }
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            if let index = attendees.firstIndex(where: { $0 == id }) {
                                let id = attendees.remove(at: index)
                                destinationAttendees.append(id)
                            }
                        } label: { moveButtonLabel }
                        .tint(.blue)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            if let index = attendees.firstIndex(where: { $0 == id }) {
                                _ = attendees.remove(at: index)
                            }
                        } label: { Label("Delete", systemImage: "trash") }
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
            readProfile: { id in profileDatabase.read(by: id) }
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
    @Previewable @State var hostAttendees: [UUID] = Array(0..<5).map { _ in UUID() }
    @Previewable @State var otherAttendees: [UUID] = []
    
    Form {
        AttendeeSections(
            hostAttendees: $hostAttendees, otherAttendees: $otherAttendees
        )
    }
}
