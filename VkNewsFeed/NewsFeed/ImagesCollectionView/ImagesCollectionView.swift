//
//  ImagesCollectionView.swift
//  VkNewsFeed
//

import UIKit

class ImagesCollectionView: UICollectionView {

    var photos = [FeedCellPhotoAttachmentViewModel]()

    init() {
        let imagesLayout = ImagesLayout()
        super.init(frame: .zero, collectionViewLayout: imagesLayout)

        delegate = self
        dataSource = self

        backgroundColor = .white
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false

        register(ImagesCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ImagesCollectionViewCell.self))

        if let imagesLayout = collectionViewLayout as? ImagesLayout {
            imagesLayout.delegate = self
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(photos: [FeedCellPhotoAttachmentViewModel]) {
        self.photos = photos
        contentOffset = CGPoint.zero
        reloadData()
    }
}

extension ImagesCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: ImagesCollectionViewCell.self),
            for: indexPath) as? ImagesCollectionViewCell else { return UICollectionViewCell() }
        cell.set(imageUrl: photos[indexPath.row].imageUrlString)
        return cell
    }
}

extension ImagesCollectionView: ImagesLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, imageAtIndexPath indexPath: IndexPath) -> CGSize {
        let width = photos[indexPath.row].width
        let height = photos[indexPath.row].height
        return CGSize(width: width, height: height)
    }
}
