//
//  SimpleMovingAverageTests.swift
//  QuantTests
//
//  Created by Marcus on 23/07/2022.
//

import XCTest

@testable import Quant

class SimpleMovingAverageTests: XCTestCase {

  func testStandartFloatingCollection() {

    XCTAssertEqual(
      [1.0, 2.0, 3.0].simpleMovingAverage(3),
      [nil, nil, 2.0])

    XCTAssertEqual(
      [2.0, 3.0, 7.0].simpleMovingAverage(3),
      [nil, nil, 4.0])

  }

  /// `QuantNumeric` covers integer types — integer division (truncating).
  func testIntegerCollection() {
    XCTAssertEqual(
      [1, 2, 3, 4].simpleMovingAverage(2),
      [nil, 1, 2, 3])
  }

  /// `QuantNumeric` covers `Decimal` (exact money) — not `FloatingPoint`.
  func testDecimalCollection() {
    let values: [Decimal] = [1, 2, 3, 4]
    XCTAssertEqual(
      values.simpleMovingAverage(2),
      [nil, Decimal(1.5), Decimal(2.5), Decimal(3.5)])
  }

  /// One-pass sliding window matches a naive re-summing reference.
  func testOnePassMatchesNaive() {
    let values = (0..<50).map { Double($0 * 37 % 11) }
    for window in 1...10 {
      let naive = values.indices.map { i -> Double? in
        guard i + 1 >= window else { return nil }
        return values[(i + 1 - window)...i].reduce(0, +) / Double(window)
      }
      XCTAssertEqual(values.simpleMovingAverage(window), naive, "window \(window)")
    }
  }

  /// Cumulative average: element i is the mean of the first i+1 elements.
  func testCumulativeAverage() {
    XCTAssertEqual(
      [1.0, 2.0, 3.0, 4.0].cumulativeAverage(),
      [1.0, 1.5, 2.0, 2.5])
  }

}
