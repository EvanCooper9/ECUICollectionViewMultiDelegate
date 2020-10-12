import Foundation

/// Some `UICollectionViewDelegate` methods require a return value. When multiple delegates are involved, it's hard to decide
/// which value to take. Implement this method to handle these scenarios.
public protocol ECReductionDelegate: AnyObject {
    
    /// - Parameters:
    ///   - first: the first value obtained by a delegate (or default value)
    ///   - second: the second value obtained by another delegate
    ///   - selector: the delegate method being called
    func reduce<ReductionType>(_ first: ReductionType, _ second: ReductionType, selector: Selector) -> ReductionType
}
