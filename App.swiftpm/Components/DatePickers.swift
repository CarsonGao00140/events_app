import SwiftUI

struct DatePickers: View {
    @Binding var start: Date
    @Binding var end: Date?
    @State private var days: Int
    
    private static func daysBetween(start: Date, end: Date) -> Int {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: start)
        let endOfDay = calendar.startOfDay(for: end)
        let components = calendar.dateComponents([.day], from: startOfDay, to: endOfDay)
        return components.day ?? 0
    }
    
    init(start: Binding<Date>, end: Binding<Date?>) {
        self._start = start
        self._end = end
        let initialDays = end.wrappedValue.flatMap { Self.daysBetween(start: start.wrappedValue, end: $0) }
        _days = State(initialValue: initialDays ?? 0)
    }
    
    private var resolvedEnd: Binding<Date> {
        Binding(
            get: { end ?? start },
            set: { newEnd in end = newEnd }
        )
    }
    
    var body: some View {
        DatePicker("Starts", selection: $start, displayedComponents: .date)
            .onChange(of: start) {
                end = Calendar.current.date(byAdding: .day, value: days, to: start) ?? end
            }
        
        HStack {
            Text("Ends")
            
            Spacer().frame(maxWidth: .infinity)
            
            if days != 0 {
                Button(action: { end = nil }) {
                    Image(systemName: "xmark.circle.fill").foregroundColor(.gray)
                }
                .buttonStyle(.plain)
            }
            
            ZStack {
                DatePicker("Ends", selection: resolvedEnd, in: start..., displayedComponents: .date)
                    .opacity(days != 0 ? 1 : 0.011)
                    .labelsHidden()
                    .onChange(of: end) {
                        days = DatePickers.daysBetween(start: start, end: resolvedEnd.wrappedValue)
                        if days == 0 { end = nil }
                    }
                
                if days == 0 {
                    Text("None")
                        .foregroundColor(.blue)
                        .padding(.leading, -41.4)
                        .allowsHitTesting(false)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var startDate: Date = Date()
    @Previewable @State var endDate: Date? = nil
    
    Form {
        Section {
            DatePickers(start: $startDate, end: $endDate)
        }
        Section {
            Text("\(startDate)")
            Text("\(String(describing: endDate))")
        }
    }
}
