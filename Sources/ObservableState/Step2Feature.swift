import SwiftUI
import ComposableArchitecture
import Helpers

@Reducer
public struct Step2Feature {
  
  @ObservableState
  public struct State: Equatable {
    let id = UUID()
    var title = "Step 2 ObservableState"
    var value = 0
  }
  
  public enum Action {
    case incrementTapped
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .incrementTapped:
        state.value += 1
        return .none
      }
    }
  }
}

public struct Step2FeatureView: View {
  
  public let store: StoreOf<Step2Feature>
  
  public var body: some View {
    WithPerceptionTracking {
      let _ = Self._printChanges()
      VStack(spacing: 20) {
        IntView(value: store.value)
        Button("Increment") {
          store.send(.incrementTapped)
        }
      }
      .navigationTitle(store.title)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(Color.random())
    }
  }
}
