import SwiftUI

struct ProfileView: View {
    @Binding var user: Attendee?
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var avatar: Image? = nil
    @State var isPresented: Bool = true
    @State var clearForm: (() -> Void)? = nil
    
    @State var clearProfile: (() -> Void)? = nil
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                AttendeeFormView(
                    firstName: $firstName,
                    lastName: $lastName,
                    avatar: $avatar,
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
