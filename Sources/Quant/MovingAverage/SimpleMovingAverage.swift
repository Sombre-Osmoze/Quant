//
//  SimpleMovingAverage.swift
//  Quant
//

import Foundation

// MARK: - Synchronous simple moving average

extension Sequence where Element: QuantNumeric {
    /// Simple moving average over a sliding window of size `n`.
    ///
    /// One pass — a running sum plus a fixed-size buffer, so the window is never
    /// re-summed (O(n) total, not O(n·window)).
    ///
    /// - Parameter n: Window length. Values ≤ 0 yield all `nil`.
    /// - Complexity: O(n) time, O(n) space (the result) plus an O(window) buffer.
    /// - Returns: `[Element?]` where element *i* is the mean of the last `n`
    ///   elements (`nil` until `n` elements have been seen).
    public func simpleMovingAverage(_ n: Int) -> [Element?] {
        guard n > 0 else { return map { _ in nil } }
        var buffer: [Element] = []
        buffer.reserveCapacity(n)
        var sum: Element = .zero
        var result: [Element?] = []
        for value in self {
            buffer.append(value)
            sum += value
            if buffer.count > n {
                sum -= buffer.removeFirst()
            }
            result.append(buffer.count == n ? sum / Element(n) : nil)
        }
        return result
    }
}

// MARK: - Asynchronous simple moving average

/// Streaming simple moving average over an `AsyncSequence`.
///
/// One pass — a running sum plus a fixed-size buffer. During warm-up (fewer
/// than `window` elements seen) it yields the *running* average of what has
/// arrived; once the window is full it yields the true `window`-element mean.
/// This keeps the stream well-defined from the first element (no `nil` gaps).
///
/// ```swift
/// let sma = AsyncSimpleMovingAverage(prices, window: 20)   // prices: AsyncSequence<Double>
/// for try await mean in sma { /* 20-period moving average */ }
/// ```
public struct AsyncSimpleMovingAverage<Base: AsyncSequence>: AsyncSequence, Sendable
where Base.Element: QuantNumeric, Base: Sendable {
    public typealias Element = Base.Element

    public let base: Base
    public let window: Int

    public init(_ base: Base, window: Int) {
        self.base = base
        self.window = window
    }

    public struct AsyncIterator: AsyncIteratorProtocol {
        var iterator: Base.AsyncIterator
        let window: Int
        var buffer: [Base.Element] = []
        var sum: Base.Element = .zero

        public mutating func next() async throws -> Base.Element? {
            guard let value = try await iterator.next() else { return nil }
            buffer.append(value)
            sum += value
            if buffer.count > window {
                sum -= buffer.removeFirst()
            }
            let n = Swift.min(buffer.count, window)
            return sum / Base.Element(n)
        }
    }

    public func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator(iterator: base.makeAsyncIterator(), window: window)
    }
}

extension AsyncSequence where Element: QuantNumeric, Self: Sendable {
    /// Wrap this async sequence in a streaming simple moving average.
    public func simpleMovingAverage(window: Int) -> AsyncSimpleMovingAverage<Self> {
        AsyncSimpleMovingAverage(self, window: window)
    }
}
