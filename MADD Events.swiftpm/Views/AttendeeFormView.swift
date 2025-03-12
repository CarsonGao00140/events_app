import SwiftUI
import PhotosUI

struct AttendeeFormView: View {
    let onChange: (String, String, Image?) -> Void
    @Binding var clear: (() -> Void)?
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var avatar: Image? = nil
    @State var picked: PhotosPickerItem?

    private func change() {
        onChange(firstName, lastName, avatar)
    }
    
    private func clearAction() {
        firstName = ""
        lastName = ""
        avatar = nil
    }

    var body: some View {
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
        .onAppear{
            clear = clearAction
        }
        .onChange(of: firstName, change)
        .onChange(of: lastName, change)
        .onChange(of: avatar, change)
        .onChange(of: picked) {
            Task {
                if let loaded = try? await picked?.loadTransferable(type: Image.self) {
                    avatar = loaded
                }
            }
        }
        .padding()
    }
}

#Preview {
    @Previewable @State var clearForm: (() -> Void)? = nil
    
    return VStack {
        AttendeeFormView(
            onChange: { firstName, lastName, avatar in
                print("First Name:", firstName, "Last Name:", lastName, "Avatar:", String(describing: avatar))
            },
             clear: $clearForm
        )
        
        Button("🛠️ Clear") {
            clearForm?()
        }
        .padding()
    }
}
