import SwiftUI

struct EventsView: View {
    @Binding var user: Attendee?
    @State var isEventFormPresented = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
            }
            .navigationTitle("Events")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isEventFormPresented = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .disabled(user == nil)
                }
            }
            .padding()
            .sheet(isPresented: $isEventFormPresented) {
                NavigationView {
//                    EventFormView(user: $user, isPresented: $isEventFormPresented)
               }
            }
        }
    }
}

#Preview{
    let user = Attendee(
        firstName: "Carson",
        lastName: "Gao",
        avatar: Image(systemName: "person.crop.circle.dashed"),
        isHost: true
    )
        
    EventsView(user: .constant(user))
}
