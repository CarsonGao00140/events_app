import SwiftUI
import PhotosUI

struct ProfileView: View {
    @Binding var user: Attendee?
    @State private var clearForm: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            AttendeeFormView(
                onChange: { firstName, lastName, avatar in
                    if firstName.isEmpty || lastName.isEmpty || avatar == nil {
                        user = nil
                    } else {
                        user = Attendee(firstName: firstName, lastName: lastName, avatar: avatar, isHost: true)
                    }
                },
                clear: $clearForm
            )
            Button("Clear", action: {
                clearForm?()
            })
        }
        .padding()
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
