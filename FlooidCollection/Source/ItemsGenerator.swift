//
//  ItemsGenerator.swift
//  FlooidCollection
//
//  Created by Martin Lalev on 6.07.19.
//  Copyright © 2019 Martin Lalev. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Cells Array Builder

public protocol CollectionViewCellArrayConvertible {
    func items() -> [CellProvider]
}
extension CellProvider: CollectionViewCellArrayConvertible {
    public func items() -> [CellProvider] { [self] }
}
extension Array: CollectionViewCellArrayConvertible where Element: CellProvider {
    public func items() -> [CellProvider] { self }
}

@resultBuilder
public struct CollectionViewCellsArrayBuilder {

    public static func buildBlock(_ components: CollectionViewCellArrayConvertible ...) -> CollectionViewCellArrayConvertible { components.flatMap { $0.items() } }

    public static func buildIf(_ component: CollectionViewCellArrayConvertible?) -> CollectionViewCellArrayConvertible { component ?? [CellProvider]() }

    public static func buildEither(first: CollectionViewCellArrayConvertible) -> CollectionViewCellArrayConvertible { first }

    public static func buildEither(second: CollectionViewCellArrayConvertible) -> CollectionViewCellArrayConvertible { second }

}

public func Section(_ identifier: String, @CollectionViewCellsArrayBuilder _ viewBuilder: () -> CollectionViewCellArrayConvertible) -> CollectionProvider.Section {
    return CollectionProvider.Section(identifier: identifier, cellProviders: viewBuilder().items())
}

// MARK: - Sections Array Builder

public protocol CollectionViewSectionArrayConvertible {
    func items() -> [CollectionProvider.Section]
}
extension CollectionProvider.Section: CollectionViewSectionArrayConvertible {
    public func items() -> [CollectionProvider.Section] { [self] }
}
extension Array: CollectionViewSectionArrayConvertible where Element == CollectionProvider.Section {
    public func items() -> [CollectionProvider.Section] { self }
}

@resultBuilder
public struct CollectionViewSectionsArrayBuilder {
    
    public static func buildBlock(_ components: CollectionViewSectionArrayConvertible ...) -> CollectionViewSectionArrayConvertible { components.flatMap { $0.items() } }
    
    public static func buildIf(_ component: CollectionViewSectionArrayConvertible?) -> CollectionViewSectionArrayConvertible { component ?? [CollectionProvider.Section]() }
    
    public static func buildEither(first: CollectionViewSectionArrayConvertible) -> CollectionViewSectionArrayConvertible { first }
    
    public static func buildEither(second: CollectionViewSectionArrayConvertible) -> CollectionViewSectionArrayConvertible { second }
    
}

public extension CollectionProvider {
    func reloadData(@CollectionViewSectionsArrayBuilder with maker: @escaping () -> CollectionViewSectionArrayConvertible, otherAnimations: @escaping () -> Void = { }, completed: @escaping () -> Void = { }) {
        self.reloadData(sections: maker().items(), otherAnimations: otherAnimations, completed: completed)
    }
}
