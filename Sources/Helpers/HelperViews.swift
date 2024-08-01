import SwiftUI

public extension Color {
  
  static func random() -> Color {
    Color(
      red: .random(in: 0...1),
      green: .random(in: 0...1),
      blue: .random(in: 0...1),
      opacity: 0.5
    )
  }
}

public struct IntView: View {
  public let value: Int
  
  public init(value: Int) {
    self.value = value
  }
  
  public var body: some View {
    Text("Value: \(value)")
      .padding()
      .background(Color.random())
  }
}
