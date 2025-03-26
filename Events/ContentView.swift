import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Events", systemImage: "calendar") {
                NavigationView {
                    EventsView()
                        .padding(.top)
                        .background(Color(.systemGroupedBackground))
                        .navigationTitle("Events")
                }
            }
            
            Tab("Profiles", systemImage: "person.2.fill") {
                NavigationView {
                    ProfilesView()
                        .padding(.top)
                        .background(Color(.systemGroupedBackground))
                        .navigationTitle("Profiles")
                }
            }
        }
    }
}
