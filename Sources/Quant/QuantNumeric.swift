import Foundation

// MARK: - QuantNumeric

/// A numeric type usable in quant primitives (moving averages, indicators).
///
/// The requirements are the *minimal* set needed to accumulate a running total
/// and divide it by a count — deliberately narrower than `Numeric` and wider
/// than `FloatingPoint`:
///
/// * `AdditiveArithmetic` — `zero`, `+`, `-` for a running sum.
/// * `/` — divide to compute a mean.
/// * `init(_ value: Int)` — turn a window/count into the element type.
///
/// Standard conformances (declared below):
///   * `Int`, `Int32`, `Int64` — integer counts/volumes. Note integer types use
///     *integer* division, so their mean truncates (map to `Double`/`Decimal`
///     for a fractional average).
///   * `Float`, `Double` — prices/volumes.
///   * `Decimal` (Foundation) — exact money. `Decimal` conforms to
///     `AdditiveArithmetic` but **not** `Numeric`, which is why a custom
///     protocol is required rather than `Numeric` or `FloatingPoint`.
public protocol QuantNumeric: AdditiveArithmetic, Sendable {
    static func / (lhs: Self, rhs: Self) -> Self
    init(_ value: Int)
}

// MARK: - Standard conformances

extension Int: QuantNumeric {}
extension Int32: QuantNumeric {}
extension Int64: QuantNumeric {}
extension Float: QuantNumeric {}
extension Double: QuantNumeric {}
extension Decimal: QuantNumeric {}
