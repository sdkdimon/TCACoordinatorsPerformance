import Foundation
import SwiftUI
import TCACoordinators

struct MinNode<Screen, V: View>: View {
  @Binding var allScreens: [Route<Screen>]
  let buildView: (Int) -> V
  let index: Int
  let truncateToIndex: (Int) -> Void
  
  @State var isAppeared = false

  init(allScreens: Binding<[Route<Screen>]>, index: Int, truncateToIndex: @escaping (Int) -> Void, @ViewBuilder buildView: @escaping (Int) -> V) {
    _allScreens = allScreens
    self.index = index
    self.truncateToIndex = truncateToIndex
    self.buildView = buildView
  }

  private var isActiveBinding: Binding<Bool> {
    return Binding(
      get: { allScreens.count > index + 1 },
      set: { isShowing in
        guard !isShowing else { return }
        guard allScreens.count > index + 1 else { return }
        guard isAppeared else { return }
        truncateToIndex(index + 1)
      }
    )
  }
  
  func truncateTo(index: Int) -> Void {
    self.allScreens = Array(self.allScreens.prefix(index))
  }

  var next: some View {
    MinNode(allScreens: $allScreens, index: index + 1, truncateToIndex: truncateToIndex, buildView: buildView)
  }

  var nextRoute: Route<Screen>? {
    allScreens[safe: index + 1]
  }

  @ViewBuilder
  var content: some View {
      buildView(index)
        .pushing(
          isActive: nextRoute?.style == .push ? isActiveBinding : .constant(false),
          destination: next
        )
        .onAppear { isAppeared = true }
        .onDisappear { isAppeared = false }
  }

  var body: some View {
    let route = allScreens[safe: index]
    // TODO: cache embedInNavigationView somehow so that navigation isn't removed when dismissing?
    if route?.embedInNavigationView ?? false {
      NavigationView {
        content
      }
      .navigationViewStyle(.stack)
    } else {
      content
    }
  }
}

struct PushingModifier<Destination: View>: ViewModifier {
  @Binding var isActiveBinding: Bool
  var destination: Destination
  
  func body(content: Content) -> some View {
    content
      .background(
        NavigationLink(
          destination: destination,
          isActive: $isActiveBinding,
          label: EmptyView.init
        )
          .hidden()
      )
  }
}

extension View {
  func pushing<Destination: View>(isActive: Binding<Bool>, destination: Destination) -> some View {
    return modifier(PushingModifier(isActiveBinding: isActive, destination: destination))
  }
}

extension Collection {
  /// Returns the element at the specified index if it is within bounds, otherwise nil.
  subscript(safe index: Index) -> Element? {
    indices.contains(index) ? self[index] : nil
  }
}
