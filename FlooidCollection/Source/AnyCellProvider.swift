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

    public init(identifier: String, reuseIdentifier: String = CellType.reuseIdentifier, setup: @escaping (CellType)->Void) {
        super.init(
            identifier: identifier,
            reuseIdentifier: reuseIdentifier,
            setup: {
                guard let cell = $0 as? CellType else { return }
                setup(cell)
            }
        )
    }

}
