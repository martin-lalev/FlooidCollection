//
//  UICollectionView+DiffingAnimation.swift
//  FlooidCollection
//
//  Created by Martin Lalev on 8.07.19.
//  Copyright © 2019 Martin Lalev. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    private func update(changes: () -> Void, animations: @escaping () -> Void, _ completed: @escaping () -> Void = { }) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completed)
        
        self.performBatchUpdates(changes)
        
        let duration = CATransaction.animationDuration();
        CATransaction.commit();
        
        UIView.animate(withDuration: duration, delay: 0, options: [.allowUserInteraction], animations: animations)
    }
    
    func update(old: [DiffableCollectionSection], new: [DiffableCollectionSection], animations: @escaping () -> Void, _ completed: @escaping () -> Void = { }) {
        guard old != new else { return completed() }

        self.update(changes: {
            
            let sectionsFrom = old.map { $0.identifier }
            let sectionsTo = new.map { $0.identifier }
            
            self.applyToSections(Changes.make(from: sectionsFrom, to: sectionsTo))
            
            for sectionIdentifier in Set(sectionsTo).intersection(sectionsFrom) {
                let sectionIndex = new.firstIndex(where: { $0.identifier == sectionIdentifier })!
                let cellsFrom = old.first(where: { $0.identifier == sectionIdentifier })!.cellIdentifiers
                let cellsTo = new.first(where: { $0.identifier == sectionIdentifier })!.cellIdentifiers
                
                self.applyToCells(Changes.make(from: cellsFrom, to: cellsTo), at: sectionIndex)
            }
        }, animations: animations, completed)
    }
    
    private func applyToSections(_ changes: Changes) {
        self.deleteSections(IndexSet(changes.deleted))
        self.insertSections(IndexSet(changes.inserted))
        for move in changes.moved { self.moveSection(move.from, toSection: move.to) }
    }
    
    private func applyToCells(_ changes: Changes, at sectionIndex: Int) {
        self.deleteItems(at: changes.deleted.map { IndexPath(row: $0, section: sectionIndex) })
        self.insertItems(at: changes.inserted.map { IndexPath(row: $0, section: sectionIndex) })
        for move in changes.moved { self.moveItem(at: IndexPath(row: move.from, section: sectionIndex), to: IndexPath(row: move.to, section: sectionIndex)) }
    }
    
}

struct DiffableCollectionSection: Equatable {
    let identifier: String
    let cellIdentifiers: [String]
    let widthIdentifiers: [String]
    let heightIdentifiers: [String]
}

struct Changes {
    
    let deleted: [Int]
    let inserted: [Int]
    let moved: [(from: Int, to: Int)]
    
    static func make(from old:[String], to new:[String]) -> Changes {
        let removedItems = Set(old).subtracting(new)
        let addedItems = Set(new).subtracting(old)
        
        return Changes(
            deleted: removedItems.compactMap {
                guard let index = old.firstIndex(of: $0) else { return nil }
                return index
            },
            inserted: new.enumerated().compactMap {
                guard addedItems.contains(new[$0.offset]) else { return nil }
                return $0.offset
            },
            moved: new.enumerated().compactMap {
                guard !addedItems.contains(new[$0.offset]) else { return nil }
                guard let j = old.firstIndex(of: new[$0.offset]) else { return nil }
                guard $0.offset != j else { return nil }
                return (from: j, to: $0.offset)
            }
        )
    }
}
