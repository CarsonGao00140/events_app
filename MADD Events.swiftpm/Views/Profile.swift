import SwiftUI
import PhotosUI

struct ProfileView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var avatar: Image?
    @State private var picked: PhotosPickerItem?
    
    var body: some View {
        VStack(spacing: 20) {
            PhotosPicker(selection: $picked, matching: .images) {
                ZStack {
                    if let avatar = avatar {
                        avatar
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray)
                    }
                }
                .frame(width: 300, height: 300)
            }
            
            TextField("First Name", text: $firstName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Last Name", text: $lastName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Clear") {
                firstName = ""
                lastName = ""
                avatar = nil
                picked = nil
            }
        }
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
