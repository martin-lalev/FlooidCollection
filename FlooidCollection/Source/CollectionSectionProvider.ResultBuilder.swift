//
//  CollectionSectionProvider.ResultBuilder.swift
//  FlooidCollection
//
//  Created by Martin Lalev on 11/07/2021.
//  Copyright © 2021 Martin Lalev. All rights reserved.
//

import UIKit

public protocol CollectionViewSectionArrayConvertible {
    func items() -> [CollectionSectionProvider]
}
extension CollectionSectionProvider: CollectionViewSectionArrayConvertible {
    public func items() -> [CollectionSectionProvider] { [self] }
}
extension Array: CollectionViewSectionArrayConvertible where Element == CollectionSectionProvider {
    public func items() -> [CollectionSectionProvider] { self }
}

@resultBuilder
public struct CollectionViewSectionsArrayBuilder {
    
    public static func buildBlock(_ components: CollectionViewSectionArrayConvertible ...) -> CollectionViewSectionArrayConvertible { components.flatMap { $0.items() } }
    
    public static func buildIf(_ component: CollectionViewSectionArrayConvertible?) -> CollectionViewSectionArrayConvertible { component ?? [CollectionSectionProvider]() }
    
    public static func buildEither(first: CollectionViewSectionArrayConvertible) -> CollectionViewSectionArrayConvertible { first }
    
    public static func buildEither(second: CollectionViewSectionArrayConvertible) -> CollectionViewSectionArrayConvertible { second }
    
}

public extension CollectionProvider {
    func reloadData(@CollectionViewSectionsArrayBuilder with maker: @escaping () -> CollectionViewSectionArrayConvertible, otherAnimations: @escaping () -> Void = { }, completed: @escaping () -> Void = { }) {
        self.reloadData(sections: maker().items(), otherAnimations: otherAnimations, completed: completed)
    }
}
