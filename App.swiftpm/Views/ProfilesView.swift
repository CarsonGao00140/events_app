import SwiftUI

struct ProfilesView: View {
    @State private var selected: Profile = .placeholder
    @State private var isFormPresented = false
    @State private var onFormSubmit: ((Profile) -> Void)?
    
    private let database = Database<Profile>.shared
    private let userDatabase = UserDatabase.shared
    
    private var user: (UUID, Profile)? { userDatabase.read() }
    
    private var other: [(UUID, Profile)] {
        var profiles = database.readAll()
        if let id = user?.0 { profiles.removeValue(forKey: id) }
        return profiles.sorted(by: { $0.value.lastName < $1.value.lastName })
    }
    
    private func deleteButton(for id: UUID) -> some View {
        Button(role: .destructive) {
            _ = database.delete(by: id)
        } label: { Label("Delete", systemImage: "trash") }
    }
    
    var body: some View {
        List {
            Section {
                if let id = user?.0, let profile = user?.1 {
                    Button(action: {
                        selected = profile
                        onFormSubmit = { newProfile in
                            _ = userDatabase.write(newProfile)
                        }
                        isFormPresented = true
                    }){ ProfileRow(profile) }
                    .foregroundColor(.primary)
                    .swipeActions(edge: .trailing) { deleteButton(for: id) }
                } else {
                    Button("Add User") {
                        onFormSubmit = { newProfile in
                            _ = userDatabase.write(newProfile)
                        }
                        isFormPresented = true
                    }
                }
            }
            
            Section {
                Button("Add Others") {
                    onFormSubmit = { newProfile in
                        _ = database.create(newProfile)
                    }
                    isFormPresented = true
                }
                
                ForEach(other, id: \.0) { (id, profile) in
                    Button(action: {
                        selected = profile
                        onFormSubmit = { newProfile in
                            _ = database.update(by: id, newProfile)
                        }
                        isFormPresented = true
                    }){ ProfileRow(profile) }
                    .foregroundColor(.primary)
                    .swipeActions(edge: .trailing) { deleteButton(for: id) }
                }
            }
        }
        .sheet(isPresented: $isFormPresented, onDismiss: {
            selected = .placeholder
        }) {
            ProfileFormView(
                isPresented: $isFormPresented,
                profile: selected,
                onSubmit: { newProfile in onFormSubmit?(newProfile) }
            )
        }
    }
}

#Preview {
    ProfilesView()
}
