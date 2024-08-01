import SwiftUI
import ComposableArchitecture
import TCACoordinators

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
    
    var routes: IdentifiedArrayOf<Route<Screen.State>>
  }
  
  public enum Action {
    case router(IdentifiedRouterActionOf<Screen>)
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
  public  let store: StoreOf<AppCoordinator>
  
  public init(store: StoreOf<AppCoordinator>) {
    self.store = store
  }
  
  public var body: some View {
    TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
      switch screen.case {
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

extension Route: ComposableArchitecture.ObservableState, Observation.Observable {
  public var _$id: ComposableArchitecture.ObservableStateID {
    switch self {
    case let .push(state):
      return ._$id(for: state)._$tag(0)
    case .sheet:
      return ObservableStateID()._$tag(1)
    case .cover:
      return ObservableStateID()._$tag(2)
    }
  }
  
  public mutating func _$willModify() {
    switch self {
    case var .push(state):
      ComposableArchitecture._$willModify(&state)
      self = .push(state)
    case .sheet:
      break
    case .cover:
      break
    }
  }
}
