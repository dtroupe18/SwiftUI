import SwiftUI

// Temperature conversion: users choose Celsius, Fahrenheit, or Kelvin.
struct TemperatureView: View {
    
    @State private var inputTemperature: Double = 0.0
    
    @State private var inputTempFormat: String = "Fahrenheit"
    @State private var outputTempFormat: String = "Fahrenheit"
    
    @FocusState private var isFocused: Bool
    
    private let tempOptions: [String] = ["Celsius", "Fahrenheit", "Kelvin"]
    
    private var convertedTemp: String {
        switch (inputTempFormat, outputTempFormat) {
            case ("Celsius", "Celsius"),
            ("Fahrenheit", "Fahrenheit"),
            ("Kelvin", "Kelvin"):
            // No conversion
            return inputTemperature.temperatureString
        case ("Celsius", "Fahrenheit"):
            // // (0°C × 9/5) + 32 = 32°F
            return (inputTemperature * 9/5 + 32).temperatureString
        case ("Celsius", "Kelvin"):
            // 0°C + 273.15 = 273.15K
            return (inputTemperature + 273.15).temperatureString
        case ("Fahrenheit", "Celsius"):
            // (32°F − 32) × 5/9 = 0°C
            return ((inputTemperature - 32) * 5/9).temperatureString
        case ("Fahrenheit", "Kelvin"):
            // (32°F − 32) × 5/9 + 273.15 = 273.15K
            return (((inputTemperature - 32) * 5/9) + 273.15).temperatureString
        case ("Kelvin", "Fahrenheit"):
            // (0K − 273.15) × 9/5 + 32 = -459.7°F
            return ((inputTemperature - 273.15) * 9/5 + 32).temperatureString
        case ("Kelvin", "Celsius"):
            // 0K − 273.15 = -273.1°C
            return (inputTemperature - 273.15).temperatureString
        default:
            // Shouldn't happen.
            return "Error"
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Input Units") {
                    Picker("Temperature Format", selection: $inputTempFormat) {
                        ForEach(tempOptions, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Section("Input Temperature") {
                    TextField("Temperature", value: $inputTemperature, format: .number)
                        .textFieldStyle(.roundedBorder)
                }
                Section("Output Units") {
                    Picker("Temperature Format", selection: $outputTempFormat) {
                        ForEach(tempOptions, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Section("Output Temperature") {
                    Text(convertedTemp)
                }
            }
            .navigationTitle("Temperature Conversion")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    TemperatureView()
}

extension Double {
    fileprivate var temperatureString: String {
        String(format: "%.2f", self)
    }
}
