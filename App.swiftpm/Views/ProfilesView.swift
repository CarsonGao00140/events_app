import SwiftUI

struct ProfilesView: View {
    @State private var selectedProfile: Profile?
    @State private var isFormPresented = false
    @State private var onFormSubmit: ((Profile) -> Void)?
    
    private let profileDatabase = Database<Profile>.shared
    private let userDatabase = UserDatabase.shared
    
    private var userProfile: (UUID, Profile)? {
        userDatabase.read()
    }
    
    private var otherProfiles: [(UUID, Profile)] {
        var profiles = profileDatabase.readAll()
        if let id = userProfile?.0 {
            profiles.removeValue(forKey: id)
        }
        return profiles.sorted(by: { $0.key < $1.key })
    }
    
    private func deleteButton(for id: UUID) -> some View {
        Button(role: .destructive) {
            _ = profileDatabase.delete(by: id)
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }
    
    var body: some View {
        List {
            Section {
                if let id = userProfile?.0, let user = userProfile?.1 {
                    Text("\(user.firstName) \(user.lastName)")
                        .onTapGesture {
                            selectedProfile = user
                            onFormSubmit = { newProfile in
                                _ = userDatabase.write(newProfile)
                            }
                            isFormPresented = true
                        }
                        .swipeActions(edge: .trailing) {
                            deleteButton(for: id)
                        }
                } else {
                    Text("Add User")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            onFormSubmit = { newProfile in
                                _ = userDatabase.write(newProfile)
                            }
                            isFormPresented = true
                        }
                }
            }
            Section {
                Text("Add Others")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        onFormSubmit = { profile in
                            let _ = profileDatabase.create(profile)
                        }
                        isFormPresented = true
                    }
                
                ForEach(otherProfiles, id: \.0) { (id, other) in
                    Text("\(other.firstName) \(other.lastName)")
                        .onTapGesture {
                            selectedProfile = other
                            onFormSubmit = { newProfile in
                                _ = profileDatabase.update(by: id, newProfile)
                            }
                            isFormPresented = true
                        }
                        .swipeActions(edge: .trailing) {
                            deleteButton(for: id)
                        }
                }
            }
        }
        .sheet(isPresented: $isFormPresented, onDismiss: {
            selectedProfile = nil
        }) {
            ProfileFormView(
                isPresented: $isFormPresented,
                initialProfile: selectedProfile,
                onSubmit: { newProfile in
                    onFormSubmit?(newProfile)
                }
            )
        }
    }
}

#Preview {
    ProfilesView()
}
