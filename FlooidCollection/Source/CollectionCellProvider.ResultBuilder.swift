//
//  CollectionCellProvider.ResultBuilder.swift
//  FlooidCollection
//
//  Created by Martin Lalev on 11/07/2021.
//  Copyright © 2021 Martin Lalev. All rights reserved.
//

import UIKit

public protocol CollectionViewCellArrayConvertible {
    func items() -> [CollectionCellProvider]
}
extension CollectionCellProvider: CollectionViewCellArrayConvertible {
    public func items() -> [CollectionCellProvider] { [self] }
}
extension Array: CollectionViewCellArrayConvertible where Element == CollectionCellProvider {
    public func items() -> [CollectionCellProvider] { self }
}

@resultBuilder
public struct CollectionViewCellsArrayBuilder {

    public static func buildBlock(_ components: CollectionViewCellArrayConvertible ...) -> CollectionViewCellArrayConvertible { components.flatMap { $0.items() } }

    public static func buildIf(_ component: CollectionViewCellArrayConvertible?) -> CollectionViewCellArrayConvertible { component ?? [CollectionCellProvider]() }

    public static func buildEither(first: CollectionViewCellArrayConvertible) -> CollectionViewCellArrayConvertible { first }

    public static func buildEither(second: CollectionViewCellArrayConvertible) -> CollectionViewCellArrayConvertible { second }

}

public extension CollectionSectionProvider {
    init(_ identifier: String, @CollectionViewCellsArrayBuilder _ viewBuilder: () -> CollectionViewCellArrayConvertible) {
        self.init(identifier: identifier, cellProviders: viewBuilder().items())
    }
}
