//
//  AnyCellProvider.swift
//  FlooidCollection
//
//  Created by Martin Lalev on 7.07.19.
//  Copyright © 2019 Martin Lalev. All rights reserved.
//

import Foundation
import UIKit

public class AnyCellProvider<CellType: IdentifiableCell>: CellProvider {
    
    private let setup: (CellType)->Void
    
    public let identifier: String
    
    public init(identifier: String, setup: @escaping (CellType)->Void) {
        self.identifier = identifier
        self.setup = setup
    }
    
    public var reuseIdentifier: String {
        return CellType.reuseIdentifier
    }

    public func setup(_ cell: UICollectionViewCell) {
        guard let cell = cell as? CellType else { return }
        self.setup(cell)
    }

}
