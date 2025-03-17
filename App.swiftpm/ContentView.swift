import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Events", systemImage: "calendar") {
                EventsView()
            }
            
            Tab("Profiles", systemImage: "person.2.fill") {
                ProfilesView()
            }
        }
    }
}
