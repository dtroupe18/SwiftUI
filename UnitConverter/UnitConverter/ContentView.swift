import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TemperatureView()
                .tabItem {
                    Label("Temperature", systemImage: "thermometer.medium")
                }
            
            LengthView()
                .tabItem {
                    Label("Length", systemImage: "ruler")
                }
        }
    }
}

#Preview {
    ContentView()
}
