import SwiftUI
import ComposableArchitecture
import Helpers

@Reducer
public struct Step1Feature {
  
  @ObservableState
  public struct State: Equatable, Identifiable {
    public let id = UUID()
    var title = "Step 1 ObservableState"
    var value = 0
    
    public init() {}
    
  }
  
  public enum Action {
    case nextStepTapped
    case incrementTapped
  }
  
  public init() {}
  
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
  
  public init(store: StoreOf<Step1Feature>) {
    self.store = store
  }
  
  public var body: some View {
    WithPerceptionTracking {
      let _ = Self._printChanges()
      VStack(spacing: 20) {
        IntView(value: store.value)
        Button("Increment") {
          store.send(.incrementTapped)
        }
        Button("Next step") {
          store.send(.nextStepTapped)
        }
      }
      .navigationTitle(store.title)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(Color.random())
    }
  }
  
}

