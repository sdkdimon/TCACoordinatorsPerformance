import SwiftUI
@_spi(Internals) import ComposableArchitecture
import TCACoordinators

extension Store where State: ObservableState, State == AppCoordinator.State, Action == AppCoordinator.Action {
  func scopedStore(index: Int) -> StoreOf<Screen>? {
    let stateKeyPath: KeyPath<AppCoordinator.State, Route<Screen.State>?> = \.routes[safe: index]
    guard var childState = self.state[keyPath: stateKeyPath]
    else { return nil }
    let actionCaseKeyPath: CaseKeyPath<AppCoordinator.Action, IndexedRouterActionOf<Screen>> = \.router
    let storeId:ScopeID<AppCoordinator.State, AppCoordinator.Action> = self.id(state: stateKeyPath, action: actionCaseKeyPath)
    let toState: ToState<AppCoordinator.State, Screen.State> =
    ToState { rootState in
// If we uncomment this the whole stack will start recomputing again
      return rootState[keyPath: stateKeyPath]?.screen ?? childState.screen
//If just return a state then stack will NOT be recomputed BUT the actions from views STOP's modifying own state
// only AppCoordinator.State modified
//      return state
    }
    return self.scope(id: storeId, state: toState) { ch in
        .router(.routeAction(id: index, action: ch))
    } isInvalid: {
      $0[keyPath: stateKeyPath] == nil
    }
  }
}

extension Screen.State: Identifiable {
  public var id: UUID {
    switch self {
    case let .landing(state):
      state.id
    case let .step1(state):
      state.id
    case let .step2(state):
      state.id
    }
  }
}

@Reducer
public struct AppCoordinator {
  
  @ObservableState
  public struct State: Equatable {
    public static let initialState = State(
      routes: [.root(.landing(.init()), embedInNavigationView: true)]
    )
    
    var routes: [Route<Screen.State>]
  }
  
  public enum Action {
    case router(IndexedRouterActionOf<Screen>)
  }
  
  public init() {}
  
  public  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .router(.routeAction(_, action: .landing(.nextStepTapped))):
        state.routes.push(.step1(Step1Feature.State()))
        return .none
        
      case .router(.routeAction(_, action: .step1(.nextStepTapped))):
        state.routes.push(.step2(Step2Feature.State()))
        return .none
        
      default:
        return .none
      }
    }
    .forEachRoute(\.routes, action: \.router)
  }
}

public struct AppCoordinatorView: View {
  @Perception.Bindable public  var store: StoreOf<AppCoordinator>
  
  public init(store: StoreOf<AppCoordinator>) {
    self.store = store
  }
  
  public var body: some View {
    WithPerceptionTracking {
      var binding = $store.routes.sending(\.router.updateRoutes)
      MinNode(allScreens: binding, index: 0, truncateToIndex: {index in binding.wrappedValue = Array(binding.wrappedValue.prefix(index)) }) { index in
        if let store = self.store.scopedStore(index: index) {
          switch store.case {
          case let .landing(store):
            LandingFeatureView(store: store)
          case let .step1(store):
            Step1FeatureView(store: store)
          case let .step2(store):
            Step2FeatureView(store: store)
          }
        }
      }
    }
  }
}



