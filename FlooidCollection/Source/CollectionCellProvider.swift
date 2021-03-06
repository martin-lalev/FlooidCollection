//
//  CollectionCellProvider.swift
//  FlooidCollection
//
//  Created by Martin Lalev on 11/07/2021.
//  Copyright © 2021 Martin Lalev. All rights reserved.
//

import UIKit

public struct CollectionCellProvider {
    
    private let setup: (UICollectionViewCell)->Void
    
    public let identifier: String
    public let reuseIdentifier: String
    
    public init(identifier: String, reuseIdentifier: String, setup: @escaping (UICollectionViewCell)->Void) {
        self.identifier = identifier
        self.reuseIdentifier = reuseIdentifier
        self.setup = setup
    }
    
    public func setup(_ cell: UICollectionViewCell) {
        self.setup(cell)
    }

}

extension CollectionCellProvider: Identifiable {
    public var id: String { self.identifier }
}
