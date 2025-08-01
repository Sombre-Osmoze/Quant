//
//  SimpleMovingAverage.swift
//  Quant
//

import Foundation

extension Sequence where Element: FloatingPoint {

  /// Compute the simple moving average, of all the element, contained in the sequence.
  /// - Parameter n: The number of element to consider.
  /// - complexity: O(n)
  /// - note: It will create a buffer of the size of the window.
  /// - Returns: A new array with the mean for each element of the sequence of nil, the element 'i' has no 'n' previous element.
  public func simpleMovingAverage(_ n: Int) -> [Element?] {
    /// The buffer is used to store the last n element.
    var buffer: [Element] = []
    var result: [Element?] = []

    for value in self {
      buffer.append(value)

      guard buffer.count >= n else {
        result.append(nil)
        continue
      }

      let suffix = buffer.suffix(n)
      result.append(suffix.reduce(Element(.zero), +) / Element(n))

      buffer.removeFirst()
    }

    return result
  }
}
