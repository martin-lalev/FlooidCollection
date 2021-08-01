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

    private let lock = NSLock()

    public func reloadData(sections: [CollectionSectionProvider], otherAnimations: @escaping () -> Void = { }, completed: @escaping () -> Void = { }) {
        guard let collectionView = self.collectionView else {
            completed()
            return
        }
        
        if sections.isEmpty {
            let changes = TableChanges.make(currentSections: self.sections, updatedSections: sections)
            self.sections = sections
            self.update(collectionView, with: changes, otherAnimations: otherAnimations, completed: completed)
        } else {
            DispatchQueue.global(qos: .userInteractive).async {
                self.lock.lock()
                let changes = TableChanges.make(currentSections: self.sections, updatedSections: sections)
                DispatchQueue.main.async {
                    self.sections = sections
                    self.update(collectionView, with: changes, otherAnimations: otherAnimations, completed: completed)
                    self.lock.unlock()
                }
            }
        }
    }
    private func update(_ collectionView: UICollectionView, with changes: TableChanges, otherAnimations: @escaping () -> Void = { }, completed: @escaping () -> Void = { }) {
        collectionView.update(changes: changes, animations: {
            for indexPath in collectionView.indexPathsForVisibleItems {
                if let cell = collectionView.cellForItem(at: indexPath) {
                    self[indexPath].setup(cell)
                }
            }
            otherAnimations()
            
        }, completed)
    }
}

extension TableChanges {
    static func make(currentSections: [CollectionSectionProvider], updatedSections: [CollectionSectionProvider]) -> TableChanges {
        return .make(
            old: currentSections.map { ($0.identifier, $0.cellProviders.map { $0.identifier }) },
            new: updatedSections.map { ($0.identifier, $0.cellProviders.map { $0.identifier }) }
        )
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
