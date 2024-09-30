//

import SwiftUI
import ComposableArchitecture

@main
struct ComposableNativeNavigationApp: App {
  static let store = StoreOf<RootFeature>(initialState: .init()) {
    RootFeature()
  }
    var body: some Scene {
        WindowGroup {
          RootView(store: Self.store)
        }
    }
}
