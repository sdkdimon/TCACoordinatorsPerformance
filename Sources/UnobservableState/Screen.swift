import Foundation
import ComposableArchitecture

@Reducer
public struct Screen: Reducer {
  
  public enum State: Equatable, Identifiable {
    case landing(LandingFeature.State)
    case step1(Step1Feature.State)
    case step2(Step2Feature.State)
    
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
  
  public enum Action {
    case landing(LandingFeature.Action)
    case step1(Step1Feature.Action)
    case step2(Step2Feature.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.landing, action: \.landing) {
      LandingFeature()
    }
    Scope(state: \.step1, action: \.step1) {
      Step1Feature()
    }
    Scope(state: \.step2, action: \.step2) {
      Step2Feature()
    }
  }
}
