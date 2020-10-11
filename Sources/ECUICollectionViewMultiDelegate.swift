import UIKit

final class ECUICollectionViewMultiDelegate: NSObject {
    
    // MARK: - Public Properties
    
    public weak var reductionDelegate: ECReductionDelegate?
    
    // MARK: - Private Properties
    
    private var delegates = [UICollectionViewDelegate]()
    
    // MARK: - Public Methods
    
    public func add(_ delegate: UICollectionViewDelegate) {
        guard delegates.allSatisfy({ !$0.isEqual(delegate) }) else { return }
        delegates.append(delegate)
    }
    
    public func remove(_ delegate: UICollectionViewDelegate) {
        delegates.removeAll { $0.isEqual(delegate) }
    }
    
    // MARK: - Private Methods
    
    private func filteredDelegates(for selector: Selector) -> [UICollectionViewDelegate] {
        delegates.filter { $0.responds(to: selector) }
    }
    
    private func layoutDelegates(for selector: Selector) -> [UICollectionViewDelegateFlowLayout] {
        filteredDelegates(for: selector).compactMap { $0 as? UICollectionViewDelegateFlowLayout }
    }
}

extension ECUICollectionViewMultiDelegate: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        let defaultValue = true
        let selector = #selector(collectionView(_:shouldHighlightItemAt:))
        return filteredDelegates(for: selector)
            .reduce(defaultValue) {
                let new = $1.collectionView?(collectionView, shouldHighlightItemAt: indexPath) ?? defaultValue
                return reductionDelegate?.reduce($0, new, selector: selector) ?? defaultValue
            }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        delegates.forEach { $0.collectionView?(collectionView, didHighlightItemAt: indexPath) }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        delegates.forEach { $0.collectionView?(collectionView, didUnhighlightItemAt: indexPath) }
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let defaultValue = true
        let selector = #selector(collectionView(_:shouldSelectItemAt:))
        return filteredDelegates(for: selector)
            .reduce(defaultValue) {
                let new = $1.collectionView?(collectionView, shouldSelectItemAt: indexPath) ?? defaultValue
                return reductionDelegate?.reduce($0, new, selector: selector) ?? defaultValue
            }
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        let defaultValue = true
        let selector = #selector(collectionView(_:shouldDeselectItemAt:))
        return filteredDelegates(for: selector)
            .reduce(defaultValue) {
                let new = $1.collectionView?(collectionView, shouldSelectItemAt: indexPath) ?? defaultValue
                return reductionDelegate?.reduce($0, new, selector: selector) ?? defaultValue
            }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegates.forEach { $0.collectionView?(collectionView, didSelectItemAt: indexPath) }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        delegates.forEach { $0.collectionView?(collectionView, didDeselectItemAt: indexPath) }
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        delegates.forEach { $0.collectionView?(collectionView, willDisplay: cell, forItemAt: indexPath) }
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        delegates.forEach { $0.collectionView?(collectionView, willDisplaySupplementaryView: view, forElementKind: elementKind, at: indexPath) }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        delegates.forEach { $0.collectionView?(collectionView, didEndDisplaying: cell, forItemAt: indexPath) }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        delegates.forEach { $0.collectionView?(collectionView, didEndDisplayingSupplementaryView: view, forElementOfKind: elementKind, at: indexPath) }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        let defaultValue = false
        let selector = #selector(collectionView(_:shouldShowMenuForItemAt:))
        return filteredDelegates(for: selector)
            .reduce(defaultValue) {
                let new = $1.collectionView?(collectionView, shouldShowMenuForItemAt: indexPath) ?? defaultValue
                return reductionDelegate?.reduce($0, new, selector: selector) ?? defaultValue
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        let defaultValue = false
        let selector = #selector(collectionView(_:canPerformAction:forItemAt:withSender:))
        return filteredDelegates(for: selector)
            .reduce(defaultValue) {
                let new = $1.collectionView?(collectionView, canPerformAction: action, forItemAt: indexPath, withSender: sender) ?? defaultValue
                return reductionDelegate?.reduce($0, new, selector: selector) ?? defaultValue
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        delegates.forEach { $0.collectionView?(collectionView, performAction: action, forItemAt: indexPath, withSender: sender) }
    }
    
    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        delegates.first?.collectionView?(collectionView, targetIndexPathForMoveFromItemAt: originalIndexPath, toProposedIndexPath: proposedIndexPath) ?? .init()
    }
    
    @available(iOS 14.0, *)
    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        // TODO: figure out default value
        let defaultValue = false
        let selector = #selector(collectionView(_:canEditItemAt:))
        return filteredDelegates(for: selector)
            .reduce(defaultValue) {
                let new = $1.collectionView?(collectionView, canEditItemAt: indexPath) ?? defaultValue
                return reductionDelegate?.reduce($0, new, selector: selector) ?? defaultValue
            }
    }
    
    @available(iOS 11.0, *)
    func collectionView(_ collectionView: UICollectionView, shouldSpringLoadItemAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
        let defaultValue = true
        let selector = #selector(collectionView(_:shouldSpringLoadItemAt:with:))
        return filteredDelegates(for: selector)
            .reduce(defaultValue) {
                let new = $1.collectionView?(collectionView, shouldSpringLoadItemAt: indexPath, with: context) ?? defaultValue
                return reductionDelegate?.reduce($0, new, selector: selector) ?? defaultValue
            }
    }
    
    @available(iOS 13.0, *)
    func collectionView(_ collectionView: UICollectionView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        // TODO: figure out default value
        let defaultValue = false
        let selector = #selector(collectionView(_:shouldBeginMultipleSelectionInteractionAt:))
        return filteredDelegates(for: selector)
            .reduce(defaultValue) {
                let new = $1.collectionView?(collectionView, shouldBeginMultipleSelectionInteractionAt: indexPath) ?? defaultValue
                return reductionDelegate?.reduce($0, new, selector: selector) ?? defaultValue
            }
    }
    
    @available(iOS 13.0, *)
    func collectionView(_ collectionView: UICollectionView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        delegates.forEach { $0.collectionView?(collectionView, didBeginMultipleSelectionInteractionAt: indexPath) }
    }
    
    @available(iOS 13.0, *)
    func collectionViewDidEndMultipleSelectionInteraction(_ collectionView: UICollectionView) {
        delegates.forEach { $0.collectionViewDidEndMultipleSelectionInteraction?(collectionView) }
    }
    
    @available(iOS 13.0, *)
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        // TODO: figure out default value
        nil
    }
    
    @available(iOS 13.0, *)
    func collectionView(_ collectionView: UICollectionView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        // TODO: figure out default value
        nil
    }
    
    @available(iOS 13.0, *)
    func collectionView(_ collectionView: UICollectionView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        // TODO: figure out default value
        nil
    }
    
    @available(iOS 13.0, *)
    func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        delegates.forEach { $0.collectionView?(collectionView, willPerformPreviewActionForMenuWith: configuration, animator: animator) }
    }
    
    @available(iOS 13.2, *)
    func collectionView(_ collectionView: UICollectionView, willDisplayContextMenu configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
        delegates.forEach { $0.collectionView?(collectionView, willDisplayContextMenu: configuration, animator: animator) }
    }
    
    @available(iOS 13.2, *)
    func collectionView(_ collectionView: UICollectionView, willEndContextMenuInteraction configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
        delegates.forEach { $0.collectionView?(collectionView, willEndContextMenuInteraction: configuration, animator: animator) }
    }
}

extension ECUICollectionViewMultiDelegate: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let defaultValue = (collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize ?? .zero
        let selector = #selector(collectionView(_:layout:sizeForItemAt:))
        return layoutDelegates(for: selector)
            .reduce(defaultValue) {
                let new = $1.collectionView?(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath) ?? defaultValue
                return reductionDelegate?.reduce($0, new, selector: selector) ?? defaultValue
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let defaultValue = (collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero
        let selector = #selector(collectionView(_:layout:insetForSectionAt:))
        return layoutDelegates(for: selector)
            .reduce(defaultValue) {
                let new = $1.collectionView?(collectionView, layout: collectionViewLayout, insetForSectionAt: section) ?? defaultValue
                return reductionDelegate?.reduce($0, new, selector: selector) ?? defaultValue
            }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let defaultValue = (collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing ?? .zero
        let selector = #selector(collectionView(_:layout:minimumLineSpacingForSectionAt:))
        return layoutDelegates(for: selector)
            .reduce(defaultValue) {
                let new = $1.collectionView?(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: section) ?? defaultValue
                return reductionDelegate?.reduce($0, new, selector: selector) ?? defaultValue
            }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let defaultValue = (collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? .zero
        let selector = #selector(collectionView(_:layout:minimumInteritemSpacingForSectionAt:))
        return layoutDelegates(for: selector)
            .reduce(defaultValue) {
                let new = $1.collectionView?(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: section) ?? defaultValue
                return reductionDelegate?.reduce($0, new, selector: selector) ?? defaultValue
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let defaultValue = (collectionViewLayout as? UICollectionViewFlowLayout)?.headerReferenceSize ?? .zero
        let selector = #selector(collectionView(_:layout:referenceSizeForHeaderInSection:))
        return layoutDelegates(for: selector)
            .reduce(defaultValue) {
                let new = $1.collectionView?(collectionView, layout: collectionViewLayout, referenceSizeForHeaderInSection: section) ?? defaultValue
                return reductionDelegate?.reduce($0, new, selector: selector) ?? defaultValue
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let defaultValue = (collectionViewLayout as? UICollectionViewFlowLayout)?.footerReferenceSize ?? .zero
        let selector = #selector(collectionView(_:layout:referenceSizeForFooterInSection:))
        return layoutDelegates(for: selector)
            .reduce(defaultValue) {
                let new = $1.collectionView?(collectionView, layout: collectionViewLayout, referenceSizeForFooterInSection: section) ?? defaultValue
                return reductionDelegate?.reduce($0, new, selector: selector) ?? defaultValue
            }
    }
}

extension ECUICollectionViewMultiDelegate: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegates.forEach { $0.scrollViewDidScroll?(scrollView) }
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        delegates.forEach { $0.scrollViewDidZoom?(scrollView) }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegates.forEach { $0.scrollViewWillBeginDragging?(scrollView) }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegates.forEach { $0.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset) }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegates.forEach { $0.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate) }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        delegates.forEach { $0.scrollViewWillBeginDecelerating?(scrollView) }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegates.forEach { $0.scrollViewDidEndDecelerating?(scrollView) }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        delegates.forEach { $0.scrollViewDidEndScrollingAnimation?(scrollView) }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        let defaultValue: UIView? = nil
        let selector = #selector(viewForZooming(in:))
        return filteredDelegates(for: selector)
            .reduce(defaultValue) {
                let new = $1.viewForZooming?(in: scrollView)
                return reductionDelegate?.reduce($0, new, selector: selector) ?? defaultValue
            }
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        delegates.forEach { $0.scrollViewWillBeginZooming?(scrollView, with: view) }
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        delegates.forEach { $0.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale) }
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        let defaultValue = false
        let selector = #selector(scrollViewShouldScrollToTop(_:))
        return filteredDelegates(for: selector)
            .reduce(defaultValue) {
                let new = $1.scrollViewShouldScrollToTop?(scrollView)
                return reductionDelegate?.reduce($0, new, selector: selector) ?? defaultValue
            }
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        delegates.forEach { $0.scrollViewDidScrollToTop?(scrollView) }
    }
    
    @available(iOS 11.0, *)
    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        delegates.forEach { $0.scrollViewDidChangeAdjustedContentInset?(scrollView) }
    }
}
