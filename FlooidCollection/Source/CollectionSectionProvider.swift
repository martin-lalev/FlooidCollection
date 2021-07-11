//
//  CollectionSectionProvider.swift
//  FlooidCollection
//
//  Created by Martin Lalev on 11/07/2021.
//  Copyright © 2021 Martin Lalev. All rights reserved.
//

public struct CollectionSectionProvider {
    public let identifier: String
    public let cellProviders: [CollectionCellProvider]

    public init(identifier: String, cellProviders: [CollectionCellProvider]) {
        self.identifier = identifier
        self.cellProviders = cellProviders
    }
}
