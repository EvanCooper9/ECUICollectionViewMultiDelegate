import Foundation

public protocol ECReductionDelegate: AnyObject {
    func reduce<ReductionType>(_ first: ReductionType, _ second: ReductionType, selector: Selector) -> ReductionType
}
