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

public protocol CellProvider {
    
    var identifier: String { get }
    var reuseIdentifier: String { get }

    func setup(_ cell: UICollectionViewCell)
    
}
