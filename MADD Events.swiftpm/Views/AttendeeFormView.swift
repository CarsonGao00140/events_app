import SwiftUI
import PhotosUI

struct AttendeeFormView: View {
    @State var firstName: String
    @State var lastName: String
    @State var avatar: Image?
    @Binding var clear: (() -> Void)?
    @Binding var isPresented: Bool
    var onChange: ((String, String, Image?, Bool) -> Void)?
    var onSubmit: ((String, String, Image?) -> Void)?
    
    @State private var picked: PhotosPickerItem?
    @FocusState private var isNameFocused: Bool
    
    private var isComplete: Bool {
        !(firstName.isEmpty || lastName.isEmpty || avatar == nil)
    }
    
    private func change() {
        onChange?(firstName, lastName, avatar, isComplete)
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
                    onSubmit?(firstName, lastName, avatar)
                    isPresented = false
                }
                .disabled(!isComplete)
            }
        }
        .padding()
        .onAppear{
            clear = clearAction
        }
        .onChange(of: picked) {
            Task {
                if let loaded = try? await picked?.loadTransferable(type: Image.self) {
                    avatar = loaded
                }
            }
        }
        .onChange(of: firstName, change)
        .onChange(of: lastName, change)
        .onChange(of: avatar, change)
    }
}

#Preview {
    @Previewable @State var clearForm: (() -> Void)?
    
    NavigationStack {
        AttendeeFormView(
            firstName: "",
            lastName: "",
            clear: $clearForm,
            isPresented: .constant(true),
            onChange: { firstName, lastName, avatar, complete in
                print("Change: \(firstName), \(lastName), \(String(describing: avatar)), \(complete)")
            },
            onSubmit: { firstName, lastName, avatar in
                print("Submit: \(firstName), \(lastName), \(String(describing: avatar))")
            }
        )
    }
    Button("🛠️ Clear", action: clearForm ?? {})
}
