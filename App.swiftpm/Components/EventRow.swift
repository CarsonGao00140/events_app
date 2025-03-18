import SwiftUI

struct EventRow: View {
    var event: Event
    
    init(_ event: Event) { self.event = event }
    
    private let profileDatabase = Database<Profile>.shared
    
    var body: some View {
        HStack(spacing: 20) {
            Text(event.name)
            
            ZStack {
                ForEach(Array(event.hostAttendees + event.otherAttendees).enumerated().map { $0 }, id: \.element) { index, id in
                    if let avatar = profileDatabase.read(by: id)?.avatar {
                        avatar
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color(white: 0.75), lineWidth: 1))
                            .frame(width: 25, height: 25)
                            .offset(x: CGFloat(index * 8), y: 0)
                    }
                }

            }
        }
    }
}

#Preview {
    let event = Event(name: "Name", location: "", startDate: Date(), hostAttendees: [], note: "")
    
    Form {
        EventRow(event)
    }
}
