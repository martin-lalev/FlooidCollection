//
//  CollectionProvider.swift
//  FlooidCollection
//
//  Created by Martin Lalev on 6.07.19.
//  Copyright © 2019 Martin Lalev. All rights reserved.
//

import UIKit

open class CollectionProvider: NSObject {
    
    private var sections: [CollectionSectionProvider] = []
    
    private weak var collectionView: UICollectionView?
    
    public func provide(for collectionView: UICollectionView) {
        collectionView.dataSource = self
        self.collectionView = collectionView
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

extension CollectionProvider: UICollectionViewDataSource {
    
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
