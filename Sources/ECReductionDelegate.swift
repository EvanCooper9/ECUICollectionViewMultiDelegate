import Foundation

protocol ECReductionDelegate: AnyObject {
    func reduce<ReductionType>(_ first: ReductionType, _ second: ReductionType, selector: Selector) -> ReductionType
}
