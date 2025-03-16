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
                            onFormSubmit = userDatabase.update
                            isFormPresented = true
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                userDatabase.delete()
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                } else {
                    Text("Add User")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            onFormSubmit = userDatabase.update
                            isFormPresented = true
                        }
                }
            }
            
            Section {
                Text("Add Others")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        onFormSubmit = othersDatabase.create
                        isFormPresented = true
                    }
                
                ForEach(othersDatabase.readAll()) { other in
                    Text("\(other.firstName) \(other.lastName)")
                        .onTapGesture {
                            selectedProfile = other
                            onFormSubmit = { newProfile in
                                _ = othersDatabase.update(by: other.id, newProfile)
                            }
                            isFormPresented = true
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                _ = othersDatabase.deleteAttendee(by: other.id)
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
                profile: selectedProfile,
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
