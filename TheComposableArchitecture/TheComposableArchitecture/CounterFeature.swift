import ComposableArchitecture
import Foundation

@Reducer
struct CounterFeature {

    @ObservableState
    struct State: Equatable {
        var count = 0
        var fact: String?
        var isLoading: Bool = false
        var isTimerRunning: Bool = false
    }

    enum Action {
        case decrementButtonTapped
        case factButtonTapped
        case factResponseFor(count: Int, fact: String)
        case incrementButtonTapped
        case timerTick
        case toggleTimerButtonTapped
    }

    enum CancelID {
        case timer
    }

    @Dependency(\.continuousClock) var clock
    @Dependency(\.numberFact) var numberFact

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                state.fact = nil
                return .none
            case .factButtonTapped:
                state.isLoading = true
                state.fact = nil

                return .run { [count = state.count] send in
                    let fact = try await self.numberFact.fetch(count)
                    await send(.factResponseFor(count: count, fact: fact))
                }
            case .factResponseFor(count: let count, fact: let fact):
                state.isLoading = false
                if count == state.count {
                    state.fact = fact
                }
                return .none
            case .incrementButtonTapped:
                state.count += 1
                state.fact = nil
                return .none

            case .timerTick:
                state.count += 1
                state.fact = nil
                return .none

            case .toggleTimerButtonTapped:
                state.isTimerRunning.toggle()

                if state.isTimerRunning {
                    return .run { send in
                        while true {
                            try await Task.sleep(for: .seconds(1))
                            await send(.timerTick)
                        }
                    }
                    .cancellable(id: CancelID.timer)
                } else {
                    return .cancel(id: CancelID.timer)
                }
            }
        }
    }
}
