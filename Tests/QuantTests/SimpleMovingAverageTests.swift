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

}
