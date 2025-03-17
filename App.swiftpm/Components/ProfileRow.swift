import SwiftUI

struct ProfileRow: View {
    var profile: Profile
    
    init(_ profile: Profile) { self.profile = profile }
    
    var body: some View {
        HStack(spacing: 12) {
            profile.avatar
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .overlay(Circle().stroke(.gray.opacity(0.3), lineWidth: 2))
                .frame(width: 25, height: 25)
            
            Text("\(profile.firstName) \(profile.lastName)")
        }
    }
}

#Preview {
    let profile = Profile(firstName: "User", lastName: "1", avatarData: nil)
    
    Form {
        ProfileRow(profile)
    }
}
