//
//  CollectionIdentifiableCell.swift
//  FlooidCollection
//
//  Created by Martin Lalev on 11/07/2021.
//  Copyright © 2021 Martin Lalev. All rights reserved.
//

import UIKit

public protocol CollectionIdentifiableCell: UICollectionViewCell {}

public extension CollectionIdentifiableCell {
    
    @MainActor
    static func makeHorizontalCell(
        identifier: String,
        reuseIdentifier: String? = nil,
        widthIdentifier: String? = nil,
        heightIdentifier: String? = nil,
        width: CollectionCellProvider.SizeMeasurement,
        height: CollectionCellProvider.SizeMeasurement = .relativeToCollectionHeight(1),
        willShow: @escaping (Self)->Void = { _ in },
        didHide: @escaping (Self)->Void = { _ in },
        prefetch: @escaping () -> Void = { },
        cancelPrefetch: @escaping () -> Void = { },
        setup: @escaping (Self) -> Void
    ) -> CollectionCellProvider {
        .init(
            identifier: identifier,
            reuseIdentifier: reuseIdentifier,
            widthIdentifier: widthIdentifier,
            heightIdentifier: heightIdentifier,
            cellType: Self.self,
            size: .init(width: width, height: height),
            willShow: {
                guard let cell = $0 as? Self else { return }
                willShow(cell)
            },
            didHide: {
                guard let cell = $0 as? Self else { return }
                didHide(cell)
            },
            prefetch: prefetch,
            cancelPrefetch: cancelPrefetch,
            setup: {
                guard let cell = $0 as? Self else { return }
                setup(cell)
            }
        )
    }
    
    @MainActor
    static func makeVerticalCell(
        identifier: String,
        reuseIdentifier: String? = nil,
        widthIdentifier: String? = nil,
        heightIdentifier: String? = nil,
        width: CollectionCellProvider.SizeMeasurement = .relativeToCollectionWidth(1),
        height: CollectionCellProvider.SizeMeasurement,
        willShow: @escaping (Self)->Void = { _ in },
        didHide: @escaping (Self)->Void = { _ in },
        prefetch: @escaping () -> Void = { },
        cancelPrefetch: @escaping () -> Void = { },
        setup: @escaping (Self) -> Void
    ) -> CollectionCellProvider {
        .init(
            identifier: identifier,
            reuseIdentifier: reuseIdentifier,
            widthIdentifier: widthIdentifier,
            heightIdentifier: heightIdentifier,
            cellType: Self.self,
            size: .init(width: width, height: height),
            willShow: {
                guard let cell = $0 as? Self else { return }
                willShow(cell)
            },
            didHide: {
                guard let cell = $0 as? Self else { return }
                didHide(cell)
            },
            prefetch: prefetch,
            cancelPrefetch: cancelPrefetch,
            setup: {
                guard let cell = $0 as? Self else { return }
                setup(cell)
            }
        )
    }

}
