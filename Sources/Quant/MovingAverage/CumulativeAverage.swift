//
//  CumulativeAverage.swift
//  Quant
//
//  Created by @Sombre-Osmoze on 18/12/2022.
//

import Foundation

// MARK: - Synchronous cumulative average

extension Sequence where Element: QuantNumeric {
    /// Running (cumulative) average: element *i* is the mean of elements 0...i.
    ///
    /// One pass — a running sum and count, never re-summing.
    ///
    /// - Complexity: O(n) time, O(n) space (the result).
    /// - Returns: A `[Element]` whose *i*-th entry is the mean of the first
    ///   *i+1* elements.
    public func cumulativeAverage() -> [Element] {
        var sum: Element = .zero
        var count = 0
        var result: [Element] = []
        for value in self {
            sum += value
            count += 1
            result.append(sum / Element(count))
        }
        return result
    }
}

// MARK: - Asynchronous cumulative average

/// A streaming cumulative average over an `AsyncSequence`.
///
/// One pass — each yielded value is the running mean up to and including the
/// current element, so a consumer can feed a live price/volume stream and read
/// a continuously-updating average without buffering the whole history.
///
/// ```swift
/// let stream = AsyncCumulativeAverage(prices)   // prices: AsyncSequence<Double>
/// for try await avg in stream { /* running mean */ }
/// ```
public struct AsyncCumulativeAverage<Base: AsyncSequence>: AsyncSequence, Sendable
where Base.Element: QuantNumeric, Base: Sendable {
    public typealias Element = Base.Element

    public let base: Base

    public init(_ base: Base) {
        self.base = base
    }

    public struct AsyncIterator: AsyncIteratorProtocol {
        var iterator: Base.AsyncIterator
        var sum: Base.Element = .zero
        var count = 0

        public mutating func next() async throws -> Base.Element? {
            guard let value = try await iterator.next() else { return nil }
            sum += value
            count += 1
            return sum / Base.Element(count)
        }
    }

    public func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator(iterator: base.makeAsyncIterator())
    }
}

extension AsyncSequence where Element: QuantNumeric, Self: Sendable {
    /// Wrap this async sequence in a streaming cumulative average.
    public func cumulativeAverage() -> AsyncCumulativeAverage<Self> {
        AsyncCumulativeAverage(self)
    }
}
