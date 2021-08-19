//
//  CollectionSectionProvider.swift
//  FlooidCollection
//
//  Created by Martin Lalev on 11/07/2021.
//  Copyright © 2021 Martin Lalev. All rights reserved.
//

import UIKit

public struct CollectionSectionProvider {
    public let identifier: String
    public let insets: UIEdgeInsets
    public let minimumLineSpacing: CGFloat
    public let minimumInteritemSpacing: CGFloat
    public let cellProviders: [CollectionCellProvider]

    public init(
        identifier: String,
        insets: UIEdgeInsets = .zero,
        minimumLineSpacing: CGFloat = 0,
        minimumInteritemSpacing: CGFloat = 0,
        cellProviders: [CollectionCellProvider]
    ) {
        self.identifier = identifier
        self.insets = insets
        self.minimumLineSpacing = minimumLineSpacing
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.cellProviders = cellProviders
    }
}
