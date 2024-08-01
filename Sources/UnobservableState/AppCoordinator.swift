import SwiftUI
import ComposableArchitecture
import TCACoordinators

@Reducer
public struct AppCoordinator {
  
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
  
  public var body: some ReducerOf<Self> {
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
    .forEachRoute(\.routes, action: \.router) {
      Screen()
    }
  }
}

public struct AppCoordinatorView: View {
  public let store: StoreOf<AppCoordinator>
  
  public init(store: StoreOf<AppCoordinator>) {
    self.store = store
  }
  
  public var body: some View {
    TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
      SwitchStore(screen) { screen in
        switch screen {
        case .landing:
          CaseLet(
            \Screen.State.landing,
             action: Screen.Action.landing,
             then: LandingFeatureView.init
          )
        case .step1:
          CaseLet(
            \Screen.State.step1,
             action: Screen.Action.step1,
             then: Step1FeatureView.init
          )
        case .step2:
          CaseLet(
            \Screen.State.step2,
             action: Screen.Action.step2,
             then: Step2FeatureView.init
          )
        }
      }
      
    }
  }
}
