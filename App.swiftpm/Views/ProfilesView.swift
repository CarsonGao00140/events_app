import SwiftUI

struct ProfilesView: View {
    @State private var selectedProfile: Profile?
    @State private var isFormPresented = false
    @State private var onFormSubmit: ((Profile) -> Void)?
    
    private var userDatabase = UserDatabase.shared
    private var othersDatabase = OthersDatabase.shared
    
    var body: some View {
        List {
            Section {
                if let user = userDatabase.read() {
                    Text("\(user.firstName) \(user.lastName)")
                        .onTapGesture {
                            selectedProfile = user
                            onFormSubmit = userDatabase.write
                            isFormPresented = true
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                _ = userDatabase.delete()
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                } else {
                    Text("Add User")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            onFormSubmit = userDatabase.write
                            isFormPresented = true
                        }
                }
            }
            Section {
                Text("Add Others")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        onFormSubmit = { profile in
                            let _ = othersDatabase.create(profile)
                        }
                        isFormPresented = true
                    }
                ForEach(othersDatabase.readAll(), id: \.0) { (id, other) in
                    Text("\(other.firstName) \(other.lastName)")
                        .onTapGesture {
                            selectedProfile = other
                            onFormSubmit = { newProfile in
                                _ = othersDatabase.update(by: id, newProfile)
                            }
                            isFormPresented = true
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                _ = othersDatabase.delete(by: id)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
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
                    print(newProfile)
                }
            )
        }
    }
}

#Preview {
    ProfilesView()
}
