//
//  SimpleMovingAverage.swift
//  Quant
//
//
//

import Foundation


public extension RandomAccessCollection where Element: FloatingPoint {

				func simpleMovingAverage() -> Element {
								precondition(!isEmpty, "can't compute an simple moving average from an empty collection")

								let zero : Element = 0
								let sum = reduce(zero, +)

								return sum / Element(count)
				}
}


public extension RandomAccessCollection where Element: BinaryInteger {
				func simpleMovingAverage() -> Element {
								precondition(!isEmpty, "test")

								let sum = reduce(0, +)

								return sum / Element(count)
				}
}
