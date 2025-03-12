import SwiftUI

struct ProfileView: View {
    @Binding var user: Attendee?
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var avatar: Image? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                AttendeeFormView(
                    firstName: user.firstName,
                    lastName: user.lastName,
                    avatar: user?.avatar,
                    isPresented: .constant(false),
                    onChange: {
                        if !(firstName.isEmpty || lastName.isEmpty || avatar == nil) {
                            user = Attendee(
                                firstName: firstName,
                                lastName: lastName,
                                avatar: avatar,
                                isHost: true
                            )
                        } else {
                            user = nil
                        }
                    }
                )
                
                Button("Clear", role: .destructive, action: {
                    firstName = ""
                    lastName = ""
                    avatar = nil
                })
                    .padding()
            }
            .navigationTitle("Profile")
            .padding()
            .onChange(of: user) {
                if let user = user {
                    firstName = user.firstName
                    lastName = user.lastName
                    avatar = user.avatar
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var user: Attendee? = nil
    
     return Group {
        ProfileView(user: $user)
        Button("🛠️ Print", action: {
            print(user as Any)
        })
    }
}
