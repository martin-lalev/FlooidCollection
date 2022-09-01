//
//  CollectionCellProvider.swift
//  FlooidCollection
//
//  Created by Martin Lalev on 11/07/2021.
//  Copyright © 2021 Martin Lalev. All rights reserved.
//

import UIKit

public struct CollectionCellProvider {
    
    public enum SizeMeasurement {
        case `static`(CGFloat)
        case dynamic((CGSize) -> CGFloat)
        case relativeToCollectionWidth(CGFloat)
        case relativeToCollectionHeight(CGFloat)
    }
    
    public struct Size {
        public init(width: CollectionCellProvider.SizeMeasurement, height: CollectionCellProvider.SizeMeasurement) {
            self.width = width
            self.height = height
        }
        
        public let width: SizeMeasurement
        public let height: SizeMeasurement
        
        public static func heightBoundRatio(_ ratio: CGFloat) -> Size {
            return .init(width: .relativeToCollectionHeight(ratio), height: .relativeToCollectionHeight(1))
        }
        
        public static func widthBoundRatio(_ ratio: CGFloat) -> Size {
            return .init(width: .relativeToCollectionWidth(1), height: .relativeToCollectionWidth(ratio))
        }

        public static func dynamicWidth(_ value: CGFloat) -> Size {
            return .init(width: .static(value), height: .relativeToCollectionHeight(1))
        }
        
        public static func dynamicHeight(_ value: CGFloat) -> Size {
            return .init(width: .relativeToCollectionWidth(1), height: .static(value))
        }
    }
    
    private let setup: (UICollectionViewCell)->Void
    private let willShow: (UICollectionViewCell)->Void
    private let didHide: (UICollectionViewCell)->Void
    private let prefetcher: () -> Void
    private let cancelPrefetcher: () -> Void
    
    public let identifier: String
    public let reuseIdentifier: String
    public let widthIdentifier: String
    public let heightIdentifier: String
    
    public let cellType: CollectionIdentifiableCell.Type
    
    private let size: Size?

    public init(
        identifier: String,
        widthIdentifier: String? = nil,
        heightIdentifier: String? = nil,
        cellType: CollectionIdentifiableCell.Type,
        size: @autoclosure () -> Size? = nil,
        willShow: @escaping (UICollectionViewCell)->Void = { _ in },
        didHide: @escaping (UICollectionViewCell)->Void = { _ in },
        prefetch: @escaping () -> Void = { },
        cancelPrefetch: @escaping () -> Void = { },
        setup: @escaping (UICollectionViewCell) -> Void
    ) {
        self.identifier = identifier
        self.reuseIdentifier = cellType.description()
        self.widthIdentifier = widthIdentifier ?? identifier
        self.heightIdentifier = heightIdentifier ?? identifier
        self.cellType = cellType
        self.size = size()
        self.setup = setup
        self.willShow = willShow
        self.didHide = didHide
        self.prefetcher = prefetch
        self.cancelPrefetcher = cancelPrefetch
    }
    
    public func setup(_ cell: UICollectionViewCell) {
        self.setup(cell)
    }
    
    public func willShow(_ cell: UICollectionViewCell) {
        self.willShow(cell)
    }
    
    public func didHide(_ cell: UICollectionViewCell) {
        self.didHide(cell)
    }
    
    public func prefetch() {
        self.prefetcher()
    }

    public func cancelPrefetch() {
        self.cancelPrefetcher()
    }

    public func size(collectionView: UICollectionView) -> CGSize {
        guard let size = self.size else { return UICollectionViewFlowLayout.automaticSize }

        let width: CGFloat = {
            switch size.width {
            case let .static(value):
                return value
            case let .relativeToCollectionWidth(value):
                return value * collectionView.bounds.width
            case let .relativeToCollectionHeight(value):
                return value * collectionView.bounds.height
            case let .dynamic(calculation):
                return calculation(collectionView.bounds.size)
            }
        }()

        let height: CGFloat = {
            switch size.height {
            case let .static(value):
                return value
            case let .relativeToCollectionWidth(value):
                return value * collectionView.bounds.width
            case let .relativeToCollectionHeight(value):
                return value * collectionView.bounds.height
            case let .dynamic(calculation):
                return calculation(collectionView.bounds.size)
            }
        }()

        return .init(width: width, height: height)
    }
    
}

extension CollectionCellProvider {
    func register(in collectionView: UICollectionView) {
        collectionView.register(self.cellType, forCellWithReuseIdentifier: self.reuseIdentifier)
    }
}

extension CollectionCellProvider: Identifiable {
    public var id: String { self.identifier }
}
