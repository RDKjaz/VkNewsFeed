//
//  ImagesLayout.swift
//  VkNewsFeed
//

import UIKit

protocol ImagesLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, imageAtIndexPath indexPath: IndexPath) -> CGSize
}

class ImagesLayout: UICollectionViewLayout {

    weak var delegate: ImagesLayoutDelegate!

    static var numberOfRows = 1
    fileprivate var cellPadding: CGFloat = 8

    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    fileprivate var contentWidth: CGFloat = 0
    fileprivate var contentHeight: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.height - (insets.left + insets.right)
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func prepare() {
        contentWidth = 0
        cache = []
        guard cache.isEmpty == true, let collectionView = collectionView else { return }
        var imagesSizes = [CGSize]()
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let imageSize = delegate.collectionView(collectionView, imageAtIndexPath: indexPath)
            imagesSizes.append(imageSize)
        }

        guard var rowHeight = ImagesLayout.rowHeight(superViewWidth: collectionView.frame.width,
                                                     imagesSizes: imagesSizes) else { return }

        rowHeight /= CGFloat(ImagesLayout.numberOfRows)

        let imagesRatios = imagesSizes.map { $0.height / $0.width}

        var yOffset = [CGFloat]()
        for row in 0 ..< ImagesLayout.numberOfRows {
            yOffset.append(CGFloat(row) * rowHeight)
        }

        var xOffset = [CGFloat](repeating: 0, count: ImagesLayout.numberOfRows)
        var row = 0
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)

            let ratio = imagesRatios[indexPath.row]
            let width = rowHeight / ratio
            let frame = CGRect(x: xOffset[row], y: yOffset[row], width: width, height: rowHeight)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attribute.frame = insetFrame
            cache.append(attribute)

            contentWidth = max(contentWidth, frame.maxX)
            xOffset[row] = xOffset[row] + width
            row = row < (ImagesLayout.numberOfRows - 1) ? (row + 1) : 0
        }
    }

    static func rowHeight(superViewWidth: CGFloat, imagesSizes: [CGSize]) -> CGFloat? {
        let imageWithMinRatio = imagesSizes.min {
            ($0.height / $0.width) < ($1.height / $1.width)
        }

        guard let imageWithMinRatio = imageWithMinRatio else { return nil }
        let difference = superViewWidth / imageWithMinRatio.width

        return imageWithMinRatio.height * difference * CGFloat(ImagesLayout.numberOfRows)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()

        for attribute in cache {
            if attribute.frame.intersects(rect) {
                visibleLayoutAttributes.append(attribute)
            }
        }

        return visibleLayoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.row]
    }
}
