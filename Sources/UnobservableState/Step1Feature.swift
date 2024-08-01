import SwiftUI
import ComposableArchitecture
import Helpers

@Reducer
public struct Step1Feature {
  
  public struct State: Equatable {
    let id = UUID()
    var title = "Step 1 UnobservableState"
    var value = 0
  }
  
  public enum Action {
    case nextStepTapped
    case incrementTapped
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .nextStepTapped:
        return .none
      case .incrementTapped:
        state.value += 1
        return .none
      }
    }
  }
}

public struct Step1FeatureView: View {
  
  public let store: StoreOf<Step1Feature>
  
  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      let _ = Self._printChanges()
      VStack(spacing: 20) {
        IntView(value: viewStore.value)
        Button("Increment") {
          viewStore.send(.incrementTapped)
        }
        Button("Next step") {
          viewStore.send(.nextStepTapped)
        }
      }
      .navigationTitle(viewStore.title)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(Color.random())
    }
  }
}
