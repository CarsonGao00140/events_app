import SwiftUI
import PhotosUI

struct AttendeeFormView: View {
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var avatar: Image?
    @Binding var isPresented: Bool
    var onChange: (() -> Void) = {}
    
    @State private var picked: PhotosPickerItem?

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                PhotosPicker(selection: $picked, matching: .images) {
                    if let avatarImage = avatar {
                        avatarImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 240, height: 240)
                            .clipShape(Circle())
                            .overlay(
                                Button(action: {
                                    avatar = nil
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.red)
                                        .clipShape(Circle())
                                },
                                alignment: .bottomTrailing
                            )
                    } else {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 240, height: 240)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                
                TextField("First Name", text: $firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Last Name", text: $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .navigationBarHidden(!isPresented)
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
            .padding()
            .onChange(of: picked) {
                Task {
                    if let loaded = try? await picked?.loadTransferable(type: Image.self) {
                        avatar = loaded
                    }
                }
            }
            .onChange(of: firstName, onChange)
            .onChange(of: lastName, onChange)
            .onChange(of: avatar, onChange)
        }
    }
}

#Preview {
    @Previewable @State var firstName: String = ""
    @Previewable @State var lastName: String = ""
    @Previewable @State var avatar: Image? = nil
    
    AttendeeFormView(
        firstName: $firstName,
        lastName: $lastName,
        avatar: $avatar,
        isPresented: .constant(true),
        onChange: {
            print("Change")
        }
    )
}
