//
//  CellProvider.swift
//  FlooidCollection
//
//  Created by Martin Lalev on 6.07.19.
//  Copyright © 2019 Martin Lalev. All rights reserved.
//

import Foundation
import UIKit

public protocol IdentifiableCell: UICollectionViewCell {
    static var reuseIdentifier: String { get }
    static func register(in view: UICollectionView)
}

public class CellProvider {
    
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
