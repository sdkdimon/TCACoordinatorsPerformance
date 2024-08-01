import SwiftUI
import UnobservableState
import ComposableArchitecture

@main
struct TCACoordinatorsPerformanceApp: App {
  static let store = StoreOf<AppCoordinator>(initialState: .initialState) {
      AppCoordinator()
  }
    var body: some Scene {
        WindowGroup {
          AppCoordinatorView(store: Self.store)
        }
    }
}
