import SwiftUI

struct ProfileView: View {
    @Binding var user: Attendee?
    @State var clearProfile: (() -> Void)? = nil
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                AttendeeFormView(
                    onChange: { firstName, lastName, avatar in
                        if firstName.isEmpty || lastName.isEmpty || avatar == nil {
                            user = nil
                        } else {
                            user = Attendee(firstName: firstName, lastName: lastName, avatar: avatar, isHost: true)
                        }
                    },
                    clear: $clearProfile
                )
                Button("Clear", role: .destructive, action: {
                    clearProfile?()
                })
            }
            .navigationTitle("Profile")
            .padding()
        }
    }
}

#Preview {
    @Previewable @State var user: Attendee? = nil
    
     return VStack {
        ProfileView(user: $user)
        Button("🛠️ Print", action: {
            print(user as Any)
        })
    }
}
