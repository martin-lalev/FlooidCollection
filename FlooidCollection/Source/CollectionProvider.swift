//
//  CollectionProvider.swift
//  FlooidCollection
//
//  Created by Martin Lalev on 6.07.19.
//  Copyright © 2019 Martin Lalev. All rights reserved.
//

import UIKit

public protocol CollectionProviderScrollDelegate: AnyObject {
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
}
public extension CollectionProviderScrollDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) { }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) { }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) { }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) { }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) { }
}

open class CollectionProvider: NSObject {
    
    private weak var scrollDelegate: CollectionProviderScrollDelegate?
    private var sections: [CollectionSectionProvider] = []
    
    private weak var collectionView: UICollectionView?
    
    public func provide(for collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        self.collectionView = collectionView
    }
    
    public func assignScrollDelegate(to scrollDelegate: CollectionProviderScrollDelegate? = nil) {
        self.scrollDelegate = scrollDelegate
    }
    
    
    
    // MARK: - Private helpers
    
    subscript(_ indexPath: IndexPath) -> CollectionCellProvider {
        return self[indexPath.section].cellProviders[indexPath.row]
    }
    
    subscript(_ index: Int) -> CollectionSectionProvider {
        return self.sections[index]
    }

    
    
    // MARK: - Reloading

    public func reloadData(sections: [CollectionSectionProvider], otherAnimations: @escaping () -> Void = { }, completed: @escaping () -> Void = { }) {
        let old = self.sections.map { $0.asDiffableSection() }
        self.sections = sections
        let new = self.sections.map { $0.asDiffableSection() }
        
        guard let collectionView = self.collectionView else {
            completed()
            return
        }
        
        collectionView.update(old: old, new: new, animations: {
            for indexPath in collectionView.indexPathsForVisibleItems {
                if let cell = collectionView.cellForItem(at: indexPath) {
                    self[indexPath].setup(cell)
                }
            }
            otherAnimations()
            
        }, completed)
    }
}

extension CollectionProvider: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDataSourcePrefetching {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self[section].cellProviders.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self[indexPath].reuseIdentifier, for: indexPath)
        self[indexPath].setup(cell)
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath.row < self[indexPath.section].cellProviders.count else { return }
        self[indexPath].willShow(cell)
    }

    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath.row < self[indexPath.section].cellProviders.count else { return }
        self[indexPath].didHide(cell)
    }

    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard indexPath.row < self[indexPath.section].cellProviders.count else { continue }
            self[indexPath].prefetch()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard indexPath.row < self[indexPath.section].cellProviders.count else { continue }
            self[indexPath].cancelPrefetch()
        }
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollDelegate?.scrollViewDidScroll(scrollView)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollDelegate?.scrollViewDidEndDecelerating(scrollView)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.scrollDelegate?.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.scrollDelegate?.scrollViewWillBeginDragging(scrollView)
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.scrollDelegate?.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }

}

extension CollectionProvider: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        self[indexPath].size(collectionView: collectionView)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        self.sections[section].insets
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        self.sections[section].minimumLineSpacing
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        self.sections[section].minimumInteritemSpacing
    }

}

private extension CollectionSectionProvider {
    func asDiffableSection() -> DiffableCollectionSection {
        DiffableCollectionSection(
            identifier: self.identifier,
            cellIdentifiers: self.cellProviders.map { $0.identifier },
            widthIdentifiers: self.cellProviders.map { $0.widthIdentifier },
            heightIdentifiers: self.cellProviders.map { $0.heightIdentifier }
        )
    }
}
