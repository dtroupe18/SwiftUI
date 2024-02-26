import SwiftUI

struct ContentView: View {
    
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 0
    @State private var tipPercentage = 20
    
    @FocusState private var isAmountFocused: Bool
    
    private let tipPercentOptions = [10, 15, 20, 25, 0]
    
    private var currencyLocale: String {
        Locale.current.currency?.identifier ?? "USD"
    }
    
    private var checkTotal: Double {
        let tipAmount = checkAmount * (Double(tipPercentage) / 100)
        return checkAmount + tipAmount
    }
    
    private var totalPerPerson: Double {
        checkTotal / Double(numberOfPeople + 2)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Check Amount") {
                    TextField("Amount", value: $checkAmount, format: .currency(code: currencyLocale))
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.decimalPad)
                        .focused($isAmountFocused)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                if isAmountFocused {
                                    Spacer()
                                    Button("Done") {
                                        isAmountFocused = false
                                    }
                                }
                            }
                        }
                }
            
                Section("Number of People") {
                    Picker("Number of People", selection: $numberOfPeople) {
                        ForEach(2 ..< 100) {
                            Text("\($0) people")
                        }
                    }
                    .labelsHidden()
                    .tint(.black)
                }
                
                Section("How much Tip would you like to leave?") {
                    Picker("Tip Percentage", selection: $tipPercentage) {
                        ForEach(0 ..< 101, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }
                    .tint(.black)
                    .pickerStyle(.navigationLink)
                }
                
                Section("Amount per person") {
                    Text(totalPerPerson, format: .currency(code: currencyLocale))
                }
                
                Section("Check total") {
                    Text(checkTotal, format: .currency(code: currencyLocale))
                }
            }
            .navigationTitle("We Split")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

#Preview {
    ContentView()
}
