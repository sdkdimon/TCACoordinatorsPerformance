import SwiftUI
import ObservableScreens
import ComposableArchitecture

@Reducer
struct RootFeature {
  @Reducer(state: .equatable)
  enum Path {
    case landing(LandingFeature)
    case step1(Step1Feature)
    case step2(Step2Feature)
  }
  
  @ObservableState
  struct State: Equatable {
    var path = StackState<Path.State>()
  }
  enum Action {
    case path(StackActionOf<Path>)
    case pushLanding
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .pushLanding:
        state.path.append(.landing(.init()))
        return .none
      case let .path(action):
        switch action {
        case .element(id: _, action: .landing(.nextStepTapped)):
          state.path.append(.step1(.init()))
        case .element(id: _, action: .step1(.nextStepTapped)):
          state.path.append(.step2(.init()))
          return .none
        default:
          return .none
        }
      }
      return .none
    }
    .forEach(\.path, action: \.path)
  }
}


struct RootView: View {
  @Perception.Bindable var store: StoreOf<RootFeature>
  
  var body: some View {
    WithPerceptionTracking {
      NavigationStack(
        path: $store.scope(state: \.path, action: \.path)
      ) {
        WithPerceptionTracking {
          Button {
            store.send(.pushLanding)
          } label: {
            Text("Push Landing Page")
          }
        }
        
      } destination: { store in
        WithPerceptionTracking {
          switch store.case {
          case .landing(let store):
            LandingFeatureView(store: store)
          case .step1(let store):
            Step1FeatureView(store: store)
          case .step2(let store):
            Step2FeatureView(store: store)
          }
        }
      }
    }
  }
}
