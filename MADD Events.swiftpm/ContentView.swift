import SwiftUI

struct ContentView: View {
    @State var user: Attendee? = nil
    
    var body: some View {
        TabView {
            Tab("Events", systemImage: "list.bullet") {
                EventsView(user: $user)
            }
            Tab("Profile", systemImage: "person.crop.circle") {
//                ProfileView(user: $user)
            }
            .badge(user == nil ? Text("!"): nil)
        }
    }
}
