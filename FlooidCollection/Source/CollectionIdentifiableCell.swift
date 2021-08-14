//
//  CollectionIdentifiableCell.swift
//  FlooidCollection
//
//  Created by Martin Lalev on 11/07/2021.
//  Copyright © 2021 Martin Lalev. All rights reserved.
//

import UIKit

public protocol CollectionIdentifiableCell: UICollectionViewCell {
    static var reuseIdentifier: String { get }
    static func register(in view: UICollectionView)
}

public extension CollectionIdentifiableCell {

    static func makeCell(
        identifier: String,
        reuseIdentifier: String = Self.reuseIdentifier,
        widthIdentifier: String? = nil,
        heightIdentifier: String? = nil,
        setup: @escaping (Self) -> Void
    ) -> CollectionCellProvider {
        .init(
            identifier: identifier,
            reuseIdentifier: reuseIdentifier,
            widthIdentifier: widthIdentifier,
            heightIdentifier: heightIdentifier,
            setup: {
                guard let cell = $0 as? Self else { return }
                setup(cell)
            }
        )
    }

}

extension UICollectionView {
    
    open func register(_ cellTypes: [CollectionIdentifiableCell.Type] = []) {
        for cellType in cellTypes {
            cellType.register(in: self)
        }
    }
    open func register(_ cellTypes: CollectionIdentifiableCell.Type ...) {
        self.register(cellTypes)
    }

}
