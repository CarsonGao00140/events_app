import SwiftUI
import PhotosUI

struct ProfileFormView: View {
    @Binding var isPresented: Bool
    @State private var firstName: String
    @State private var lastName: String
    @State private var avatar: Image
    @State private var photo: PhotosPickerItem?

    private let initialProfile: Profile
    private var submit: (Profile) -> Void

    init(isPresented: Binding<Bool>, profile: Profile? = nil, onSubmit: @escaping (Profile) -> Void) {
        self._isPresented = isPresented
        initialProfile = profile ?? .placeholder
        _firstName = State(initialValue: initialProfile.firstName)
        _lastName = State(initialValue: initialProfile.lastName)
        _avatar = State(initialValue: initialProfile.avatar)
        submit = onSubmit
    }
    
    private var isValid: Bool {
        Profile.isValid(newProfile) && newProfile != initialProfile
    }
    
    private var newProfile: Profile {
        .init(
            firstName: firstName,
            lastName: lastName,
            avatar: avatar
        )
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    PhotosPicker(selection: $photo, matching: .images) {
                        avatar
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 240, height: 240)
                            .frame(maxWidth: .infinity)
                            .overlay(alignment: .bottomTrailing) {
                                if avatar != Profile.placeholder.avatar {
                                    Button {
                                        avatar = Profile.placeholder.avatar
                                    } label: {
                                        Image(systemName: "arrow.counterclockwise.circle.fill")
                                            .font(.system(size: 32))
                                    }
                                    .offset(x: -16, y: -16)
                                }
                            }
                    }       .listRowBackground(Color.clear)
                }
                Section {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                }
            }
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
                        submit(newProfile)
                        isPresented = false
                    }
                    .disabled(!isValid)
                }
            }
            .onChange(of: photo) {
                Task {
                    if let loaded = try await photo?.loadTransferable(type: Image.self) {
                        avatar = loaded
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileFormView(isPresented: .constant(true)) { newProfile in
        print(newProfile as Any)
    }
}
