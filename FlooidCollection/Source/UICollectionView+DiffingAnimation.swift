//
//  UICollectionView+DiffingAnimation.swift
//  FlooidCollection
//
//  Created by Martin Lalev on 8.07.19.
//  Copyright © 2019 Martin Lalev. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    
    func update(old: [(String, [String])], new: [(String, [String])], _ completed: @escaping () -> Void = { }) {
        self.performBatchUpdates({
            let sectionsFrom = old.map { $0.0 }
            let sectionsTo = new.map { $0.0 }
            
            self.applyToSections(Changes.make(from: sectionsFrom, to: sectionsTo))
            
            for sectionIdentifier in Set(sectionsTo).intersection(sectionsFrom) {
                let sectionIndex = new.firstIndex(where: { $0.0 == sectionIdentifier })!
                let cellsFrom = old.first(where: { $0.0 == sectionIdentifier })!.1
                let cellsTo = new.first(where: { $0.0 == sectionIdentifier })!.1
                
                self.applyToCells(Changes.make(from: cellsFrom, to: cellsTo), at: sectionIndex)
            }
        }, completion: { _ in completed() })
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
