//
//  ProvidedCollectionView.swift
//  FlooidCollection
//
//  Created by Martin Lalev on 16.05.20.
//  Copyright © 2020 Martin Lalev. All rights reserved.
//

import Foundation

open class ProvidedCollectionView: UICollectionView {
    
    private(set) public var collectionProvider = CollectionProvider()
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.provide()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.provide()
    }
    
    open func register(_ cellTypes: [IdentifiableCell.Type] = []) {
        for cellType in cellTypes {
            cellType.register(in: self)
        }
    }
    open func register(_ cellTypes: IdentifiableCell.Type ...) {
        self.register(cellTypes)
    }
    func provide() {
        DispatchQueue.main.async {
            self.collectionProvider.provide(for: self)
        }
    }

}
