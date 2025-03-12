import SwiftUI
import PhotosUI

struct AttendeeFormView: View {
    @State var firstName: String
    @State var lastName: String
    @State var avatar: Image?
    @Binding var isPresented: Bool
    var onChange: (() -> Void)?
    var onDone: ((String, String, Image?) -> Void)?
    
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
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", role: .destructive) {
                        isPresented = false
                    }
                    .foregroundColor(.red)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        onDone?(firstName, lastName, avatar)
                        isPresented = false
                    }
                    .disabled(firstName.isEmpty || lastName.isEmpty || avatar == nil)
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
            .onChange(of: firstName, onChange ?? {})
            .onChange(of: lastName, onChange ?? {})
            .onChange(of: avatar, onChange ?? {})
        }
    }
}

#Preview {
    @Previewable @State var firstName: String = ""
    @Previewable @State var lastName: String = ""
    @Previewable @State var avatar: Image? = nil
    
    AttendeeFormView(
        firstName: firstName,
        lastName: lastName,
        avatar: avatar,
        isPresented: .constant(true),
        onChange: {
            print("Change")
        },
        onDone: { _, _, _ in
            print("Done")
        }
    )
}
