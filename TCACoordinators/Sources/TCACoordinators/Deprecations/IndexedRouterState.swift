import Foundation

/// A protocol standardizing naming conventions for state types that contain routes
/// within an `IdentifiedArray`.
@available(*, deprecated, message: "Obsoleted, can be removed from your State type")
public protocol IndexedRouterState {
  associatedtype Screen

  /// An array of screens, identified by index, representing a navigation/presentation stack.
  var routes: [Route<Screen>] { get set }
}
