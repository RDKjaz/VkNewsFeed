//
//  FeedCellLayoutCalculator.swift
//  VkNewsFeed
//

import UIKit

protocol FeedCellLayoutCalculatorProtocol {
    func sizes(postText: String?,
               imageAttachments: [FeedCellPhotoAttachmentViewModel],
               isFullSizedPost: Bool) -> FeedCellSizes
}

struct Sizes: FeedCellSizes {
    var postLabelFrame: CGRect
    var moreTextButtonFrame: CGRect
    var postImageFrame: CGRect
    var bottomViewFrame: CGRect
    var totalHeight: CGFloat
}

final class FeedCellLayoutCalculator: FeedCellLayoutCalculatorProtocol {

    private let screenWidth: CGFloat

    init(screenWidth: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)) {
        self.screenWidth = screenWidth
    }

    func sizes(postText: String?,
               imageAttachments: [FeedCellPhotoAttachmentViewModel],
               isFullSizedPost: Bool) -> FeedCellSizes {
        let cardInsets = UIEdgeInsets(top: 0, left: 8, bottom: 12, right: 8)
        let postLabelInsets = UIEdgeInsets(top: 8 + 36 + 8, left: 8, bottom: 8, right: 8)
        let moreTextButtonInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)

        var isHiddenMoreTextButton = true
        let cardViewWidth = screenWidth - cardInsets.left - cardInsets.right

        var postLabelFrame = CGRect(origin: CGPoint(x: postLabelInsets.left, y: postLabelInsets.top), size: CGSize.zero)

        if let text = postText, !text.isEmpty {
            let width = cardViewWidth - postLabelInsets.left - postLabelInsets.right
            var height = text.height(width: width, font: UIFont.systemFont(ofSize: 15))

            let limitHeight = UIFont.systemFont(ofSize: 15).lineHeight * CGFloat(8)

            if !isFullSizedPost && height > limitHeight {
                height = UIFont.systemFont(ofSize: 15).lineHeight * CGFloat(6)
                isHiddenMoreTextButton = false
            }

            postLabelFrame.size = CGSize(width: width, height: height)
        }

        var moreTextButtonSize = CGSize.zero

        if !isHiddenMoreTextButton {
            moreTextButtonSize = CGSize(width: 170, height: 30)
        }

        let moreTextButtonOrigin = CGPoint(x: moreTextButtonInsets.left, y: postLabelFrame.maxY)

        let moreTextButtonFrame = CGRect(origin: moreTextButtonOrigin, size: moreTextButtonSize)

        let attachmentTop = postLabelFrame.size == CGSize.zero
            ? postLabelInsets.top
            : moreTextButtonFrame.maxY + postLabelInsets.bottom

        var attachmentFrame = CGRect(origin: CGPoint(x: 0, y: attachmentTop), size: CGSize.zero)

        if let imageAttachment = imageAttachments.first {
            let ratio = Float(imageAttachment.height) / Float(imageAttachment.width)
            if imageAttachments.count == 1 {
                attachmentFrame.size = CGSize(width: cardViewWidth, height: cardViewWidth * CGFloat(ratio))
            } else if imageAttachments.count > 1 {
                var images = [CGSize]()
                for image in imageAttachments {
                    let imageSize = CGSize(width: CGFloat(image.width), height: CGFloat(image.height))
                    images.append(imageSize)
                }

                let rowheight = ImagesLayout.rowHeight(superViewWidth: cardViewWidth, imagesSizes: images)
                attachmentFrame.size = CGSize(width: cardViewWidth, height: rowheight!)
            }
        }

        let bottomViewTop = max(postLabelFrame.maxY, attachmentFrame.maxY)
        let bottomViewFrame = CGRect(origin: CGPoint(x: 0, y: bottomViewTop),
                                     size: CGSize(width: cardViewWidth, height: 44))
        let totalHeight = bottomViewFrame.maxY + cardInsets.bottom
        return Sizes(postLabelFrame: postLabelFrame,
                     moreTextButtonFrame: moreTextButtonFrame,
                     postImageFrame: attachmentFrame,
                     bottomViewFrame: bottomViewFrame,
                     totalHeight: totalHeight)
    }
}
