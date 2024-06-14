import ComposableArchitecture
import SwiftUI

@main
struct TheComposableArchitectureApp: App {
    static let store = Store(initialState: CounterFeature.State(), reducer: {
        CounterFeature()
            ._printChanges()
    })

    var body: some Scene {
        WindowGroup {
            CounterView(store: TheComposableArchitectureApp.store)
        }
    }
}
