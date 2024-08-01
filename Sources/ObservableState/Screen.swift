import ComposableArchitecture

@Reducer(state: .equatable)
public enum Screen {
  case landing(LandingFeature)
  case step1(Step1Feature)
  case step2(Step2Feature)
}
