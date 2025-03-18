import SwiftUI

private struct Avatar: View {
    let image: Image
    
    var body: some View {
        image
            .resizable()
            .scaledToFill()
            .clipShape(Circle())
            .overlay(Circle().stroke(Color(white: 0.8), lineWidth: 1.5))
            .frame(width: 25, height: 25)
    }
}

struct EventRow: View {
    let event: Event
    init(_ event: Event) { self.event = event }
    
    private let profileDatabase = Database<Profile>.shared
    
    var body: some View {
        HStack(spacing: 20) {
            Text(event.name)
            let avatars = (event.hostAttendees + event.otherAttendees)
                .map { profileDatabase.read(by: $0)?.avatar ?? Profile.placeholder.avatar }
            
            ZStack {
                ForEach(avatars.indices, id: \.self) { index in
                    Avatar(image: avatars[index])
                        .offset(x: CGFloat(index * 8), y: 0)
                }
            }
        }
    }
}

struct ProfileRow: View {
    let profile: Profile
    init(_ profile: Profile) { self.profile = profile }
    
    var body: some View {
        HStack(spacing: 12) {
            Avatar(image: profile.avatar)
            Text("\(profile.firstName) \(profile.lastName)")
        }
    }
}

#Preview {
    let profile = Profile(firstName: "User", lastName: "1", avatarData: nil)
    let event = Event(name: "Name", location: "", startDate: Date(), hostAttendees: [], note: "")
    
    List {
        Section { ProfileRow(profile) }
        Section { EventRow(event) }
    }
}
