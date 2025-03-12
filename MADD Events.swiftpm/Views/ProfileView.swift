import SwiftUI

struct ProfileView: View {
    @Binding var user: Attendee?
    
    @State private var clearForm: (() -> Void)?

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                AttendeeFormView(
                    firstName: user?.firstName ?? "",
                    lastName: user?.lastName ?? "",
                    avatar: user?.avatar,
                    clear: $clearForm,
                    isPresented: .constant(false),
                    onChange: {firstName, lastName, avatar, isComplete in
                        user = isComplete
                            ? Attendee(
                                firstName: firstName,
                                lastName: lastName,
                                avatar: avatar,
                                isHost: true
                            )
                            : nil
                    }
                )
                
                Button("Clear", role: .destructive, action: clearForm ?? {})
                    .padding()
            }
            .navigationTitle("Profile")
            .padding()
        }
    }
}

#Preview {
    @Previewable @State var user: Attendee? = nil
    
    ProfileView(user: $user)
    Button("🛠️ Print", action: {
        print(user as Any)
    })
}
