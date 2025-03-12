import SwiftUI

struct EventsView: View {
    @Binding var user: Attendee?
    @State var showEventForm = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
            }
            .navigationTitle("Events")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showEventForm = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .disabled(user == nil)
                }
            }
            .padding()
            .sheet(isPresented: $showEventForm) {
                NavigationView {
                    EventFormView(user: $user, isPresented: $showEventForm)
               }
            }
        }
    }
}

#Preview{
    let user = Attendee(
        firstName: "Carson",
        lastName: "Gao",
        avatar: Image(systemName: "person.circle"),
        isHost: true
    )
        
    EventsView(user: .constant(user))
}
