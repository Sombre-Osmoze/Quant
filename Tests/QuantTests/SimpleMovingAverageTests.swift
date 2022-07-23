//
//  SimpleMovingAverageTests.swift
//  QuantTests
//
//  Created by Marcus on 23/07/2022.
//

import XCTest

class SimpleMovingAverageTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


				func testStandartFloatingCollection() {

								XCTAssertEqual([1.0, 2.0, 3.0].simpleMovingAverage(),
																							2)


								XCTAssertEqual([2.0, 3.0, 7.0].simpleMovingAverage(),
																							4.0)
				}


				func testStandartIntegerCollection() {

								XCTAssertEqual([1, 2, 3].simpleMovingAverage(),
																							2)


								XCTAssertEqual([2, 3, 7].simpleMovingAverage(),
																							4)
				}



}
