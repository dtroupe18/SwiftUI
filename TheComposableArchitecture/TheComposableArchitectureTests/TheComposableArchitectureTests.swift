import ComposableArchitecture
import XCTest

@testable import TheComposableArchitecture

final class CounterFeatureTests: XCTestCase {

    @MainActor
    func testCounter() async {

        let store = TestStore(initialState: CounterFeature.State(), reducer: {
            CounterFeature()
        })

        await store.send(.incrementButtonTapped) {
            $0.count = 1
        }

        await store.send(.decrementButtonTapped) {
            $0.count = 0
        }
    }

    @MainActor
    func testTimer() async {
        let clock = TestClock()

        let store = TestStore(
            initialState: CounterFeature.State(),
            reducer: {
                CounterFeature()
            }, 
            withDependencies: {
                $0.continuousClock = clock
            }
        )

        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = true
        }

        await clock.advance(by: .seconds(1))
        await store.receive(\.timerTick) {
            $0.count = 1
        }

        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = false
        }
    }

    @MainActor
    func testNumberFact() async {
        let store = TestStore(initialState: CounterFeature.State(), reducer: {
            CounterFeature()
        }, withDependencies: {
            $0.numberFact.fetch = { "\($0) is a good number." }
        })

        await store.send(.factButtonTapped) {
            $0.isLoading = true
        }

        // (count: let count, fact: let fact)
        await store.receive(\.factResponseFor, timeout: .seconds(3)) {
            $0.isLoading = false
            $0.fact = "0 is a good number."
        }
    }
}
