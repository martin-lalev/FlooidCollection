//
//  ProvidedCollectionView.swift
//  FlooidCollection
//
//  Created by Martin Lalev on 16.05.20.
//  Copyright © 2020 Martin Lalev. All rights reserved.
//

import Foundation

open class ProvidedCollectionView: UICollectionView {
    
    private(set) public var collectionProvider = CollectionProvider(with: { _ in })
    
    open func register(_ cellTypes: [IdentifiableCell.Type] = []) {
        for cellType in cellTypes {
            cellType.register(in: self)
        }
    }
    open func register(_ cellTypes: IdentifiableCell.Type ...) {
        self.register(cellTypes)
    }
    open func provide(_ maker: @escaping (ItemsGenerator<CollectionProvider.Section>) -> Void) {
        self.collectionProvider = CollectionProvider(with: maker)
        self.collectionProvider.provide(for: self)
    }

}
