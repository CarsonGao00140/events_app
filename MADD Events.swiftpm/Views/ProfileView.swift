//import SwiftUI
//
//struct ProfileView: View {
//    @Binding var user: Attendee?
//    @State var clearProfile: (() -> Void)? = nil
//    
//    var body: some View {
//        NavigationStack {
//            VStack(spacing: 20) {
//                AttendeeFormView(
//                    onChange: { firstName, lastName, avatar in
//                        if firstName.isEmpty || lastName.isEmpty || avatar == nil {
//                            user = nil
//                        } else {
//                            user = Attendee(firstName: firstName, lastName: lastName, avatar: avatar, isHost: true)
//                        }
//                    },
//                    clear: $clearProfile,
//                    isPresented: .constant(false)
//                )
//                
//                Button("Clear", role: .destructive, action: clearProfile ?? {})
//                    .padding()
//            }
//            .navigationTitle("Profile")
//            .padding()
//        }
//    }
//}
//
//#Preview {
//    @Previewable @State var user: Attendee? = nil
//    
//     return Group {
//        ProfileView(user: $user)
//        Button("🛠️ Print", action: {
//            print(user as Any)
//        })
//    }
//}
