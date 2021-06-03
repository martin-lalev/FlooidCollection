//
//  ItemsGenerator.swift
//  FlooidCollection
//
//  Created by Martin Lalev on 6.07.19.
//  Copyright © 2019 Martin Lalev. All rights reserved.
//

import Foundation
import UIKit

public class ItemsGenerator<Item> {
    
    var items: [Item] = []
    init() { }
    
    @discardableResult
    public func append(_ provider: Item) -> ItemsGenerator {
        self.items.append(provider)
        return self
    }
    
    @discardableResult
    public func append(_ provider: Item?) -> ItemsGenerator {
        guard let provider = provider else { return self }
        self.items.append(provider)
        return self
    }
    
    @discardableResult
    public func append(_ providers: [Item]) -> ItemsGenerator {
        self.items.append(contentsOf: providers)
        return self
    }
}


// MARK: - Helpers

public extension CollectionProvider {
    func reloadData(with maker: @escaping (ItemsGenerator<CollectionProvider.Section>) -> Void, otherAnimations: @escaping () -> Void = { }, completed: @escaping () -> Void = { }) {
        self.reloadData(sections: List(maker), otherAnimations: otherAnimations, completed: completed)
    }
}

public func Section(_ identifier: String, _ maker: (ItemsGenerator<CellProvider>) -> Void) -> CollectionProvider.Section {
    return CollectionProvider.Section(identifier: identifier, cellProviders: List(maker))
}

public func List<Item>(_ maker: (ItemsGenerator<Item>) -> Void) -> [Item] {
    let generator: ItemsGenerator<Item> = ItemsGenerator()
    maker(generator)
    return generator.items
}

public func If<Item>(_ expression: Bool, then: (ItemsGenerator<Item>) -> Void = { _ in }, `else`: (ItemsGenerator<Item>) -> Void = { _ in }) -> [Item] {
    if expression {
        return List(then)
    } else {
        return List(`else`)
    }
}

public func Unwrap<Item, T>(_ value: T?, then: (ItemsGenerator<Item>, T) -> Void = { _, _ in }, `else`: (ItemsGenerator<Item>) -> Void = { _ in }) -> [Item] {
    if let value = value {
        let generator: ItemsGenerator<Item> = ItemsGenerator()
        then(generator, value)
        return generator.items
    } else {
        return List(`else`)
    }
}
