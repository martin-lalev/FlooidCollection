//
//  CollectionCellProvider.ResultBuilder.swift
//  FlooidCollection
//
//  Created by Martin Lalev on 11/07/2021.
//  Copyright © 2021 Martin Lalev. All rights reserved.
//

import UIKit

@MainActor
public protocol CollectionViewCellArrayConvertible {
    func items() -> [CollectionCellProvider]
}
@MainActor
extension CollectionCellProvider: CollectionViewCellArrayConvertible {
    public func items() -> [CollectionCellProvider] { [self] }
}
extension Array: CollectionViewCellArrayConvertible where Element == CollectionCellProvider {
    public func items() -> [CollectionCellProvider] { self }
}

@MainActor
@resultBuilder
public struct CollectionViewCellsArrayBuilder {

    public static func buildBlock(_ components: CollectionViewCellArrayConvertible ...) -> CollectionViewCellArrayConvertible { components.flatMap { $0.items() } }

    public static func buildIf(_ component: CollectionViewCellArrayConvertible?) -> CollectionViewCellArrayConvertible { component ?? [CollectionCellProvider]() }

    public static func buildEither(first: CollectionViewCellArrayConvertible) -> CollectionViewCellArrayConvertible { first }

    public static func buildEither(second: CollectionViewCellArrayConvertible) -> CollectionViewCellArrayConvertible { second }

    public static func buildArray(_ components: CollectionViewCellArrayConvertible) -> CollectionViewCellArrayConvertible { components }

    public static func buildArray(_ components: [CollectionViewCellArrayConvertible]) -> CollectionViewCellArrayConvertible { components.flatMap { $0.items() } }
    
}

@MainActor
public extension CollectionSectionProvider {
    init(
        _ identifier: String,
        insets: UIEdgeInsets = .zero,
        minimumLineSpacing: CGFloat = 0,
        minimumInteritemSpacing: CGFloat = 0,
        @CollectionViewCellsArrayBuilder _ viewBuilder: () -> CollectionViewCellArrayConvertible
    ) {
        self.init(
            identifier: identifier,
            insets: insets,
            minimumLineSpacing: minimumLineSpacing,
            minimumInteritemSpacing: minimumInteritemSpacing,
            cellProviders: viewBuilder().items()
        )
    }
}
