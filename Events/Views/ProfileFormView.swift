import SwiftUI
import PhotosUI

struct ProfileFormView: View {
    @Binding var isPresented: Bool
    @State private var firstName: String
    @State private var lastName: String
    @State private var avatarData: Data?
    @State private var photo: PhotosPickerItem?

    private let profile: Profile
    private let submit: (Profile) -> Void

    init(isPresented: Binding<Bool>, profile: Profile, onSubmit: @escaping (Profile) -> Void) {
        self._isPresented = isPresented
        self.profile = profile
        _firstName = State(wrappedValue: profile.firstName)
        _lastName = State(wrappedValue: profile.lastName)
        _avatarData = State(wrappedValue: profile.avatarData)
        submit = onSubmit
    }
    
    private var isValid: Bool { Profile.isValid(newProfile) && newProfile != profile }
    
    private var newProfile: Profile {
        .init(
            firstName: firstName,
            lastName: lastName,
            avatarData: avatarData
        )
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    PhotosPicker(selection: $photo, matching: .images) {
                        newProfile.avatar
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 240, height: 240)
                            .frame(maxWidth: .infinity)
                            .overlay(alignment: .bottomTrailing) {
                                if profile.avatarData != nil && avatarData != profile.avatarData {
                                    Button {
                                        avatarData = profile.avatarData
                                    } label: {
                                        Image(systemName: "arrow.counterclockwise.circle.fill")
                                            .font(.system(size: 32))
                                    }
                                    .offset(x: -16, y: -16)
                                }
                            }
                    }
                    .listRowBackground(Color.clear)
                    .onChange(of: photo) {
                        Task {
                            if let data = try await photo?.loadTransferable(type: Data.self) {
                                avatarData = data
                            }
                        }
                    }
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
                    Button("Cancel", role: .cancel) { isPresented = false }
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
        }
    }
}

#Preview {
    ProfileFormView(isPresented: .constant(true), profile: .placeholder) { newProfile in
        print(newProfile)
    }
}
