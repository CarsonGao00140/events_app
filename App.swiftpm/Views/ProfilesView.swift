import SwiftUI

struct ProfilesView: View {
    @State var userDatabase = UserDatabase.shared
    
    var body: some View {
        List {
            Section {
                if userDatabase.user == nil {
                    Text("Add User")
                        .foregroundColor(.blue)
                } else {
                    Text("User")
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                userDatabase.delete()
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
        }
    }
}

#Preview {
    ProfilesView()
}
