//
//  NewsFeedPresenter.swift
//  VkNewsFeed
//

import UIKit

protocol NewsFeedPresentationLogic {
    func presentData(response: ResponseType)
}

class NewsFeedPresenter: NewsFeedPresentationLogic {

    weak var viewController: NewsFeedDisplayLogic?

    var cellLayoutCalculator: FeedCellLayoutCalculatorProtocol = FeedCellLayoutCalculator()

    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMM 'в' HH:mm"
        return dateFormatter
    }()

    func presentData(response: ResponseType) {
        switch response {
        case .presentNewsFeed(let feed, let relvealedPostIds):
            let cells = feed.items.map { item in
                cellViewModel(from: item, profiles: feed.profiles, groups: feed.groups, relvealedPostIds: relvealedPostIds)
            }

            let feedViewModel = FeedViewModel(cells: cells)

            viewController?.displayData(viewModel: .displayNewsFeed(feedViewModel: feedViewModel))
        case .presentUserInfo(user: let user):
            let userViewModel = UserViewModel.init(imageUrlSrting: user?.photo100)
            viewController?.displayData(viewModel: .displayUser(userViewModel: userViewModel))
        }
    }

    private func cellViewModel(from feedItem: FeedItem, profiles: [Profile], groups: [Group], relvealedPostIds: [Int]) -> FeedViewModel.Cell {

        let profileRepresentable = getProfileOrGroup(from: feedItem.sourceId, profiles: profiles, groups: groups)

        let dateString = dateFormatter.string(from: Date(timeIntervalSince1970: feedItem.date))

        let imageAttachments = self.imageAttachments(feedItem: feedItem)

        let isFullSized = relvealedPostIds.contains(feedItem.postId)

        let sizes = cellLayoutCalculator.sizes(postText: feedItem.text, imageAttachments: imageAttachments, isFullSizedPost: isFullSized)

        return FeedViewModel.Cell.init(postId: feedItem.postId,
                                       topImageUrlString: profileRepresentable.photo,
                                       name: profileRepresentable.name,
                                       date: dateString,
                                       text: feedItem.text,
                                       imageAttachments: imageAttachments,
                                       likes: formattedCounter(feedItem.likes?.count),
                                       comments: formattedCounter(feedItem.comments?.count),
                                       reposts: formattedCounter(feedItem.reposts?.count),
                                       views: formattedCounter(feedItem.views?.count),
                                       sizes: sizes)
    }
    
    private func formattedCounter(_ counter: Int?) -> String? {
        guard let counter = counter, counter > 0 else { return nil }
        var counterString = String(counter)
        let count = counterString.count
        if count < 6 && count > 4 {
            counterString = String(counterString.dropLast(3)) + "K"
        } else if count > 6 {
            counterString = String(counterString.dropLast(6)) + "M"
        }
        return counterString
    }

    private func getProfileOrGroup(from sourceId: Int, profiles: [Profile], groups: [Group]) -> ProfileRepresentable {
        let profilesOrGroups: [ProfileRepresentable] = sourceId >= 0 ? profiles : groups
        let normalSourceId = sourceId >= 0 ? sourceId : -sourceId

        return profilesOrGroups.first { $0.id == normalSourceId }!
    }

    private func imageAttachment(feedItem: FeedItem) -> FeedViewModel.FeedCellPhotoAttachment? {
        guard let images = feedItem.attachments?.compactMap({ attachment in
            attachment.photo
        }), let firstImage = images.first else {
            return nil
        }

        return FeedViewModel.FeedCellPhotoAttachment.init(imageUrlString: firstImage.srcBIG, width: firstImage.width, height: firstImage.height)
    }

    private func imageAttachments(feedItem: FeedItem) -> [FeedViewModel.FeedCellPhotoAttachment] {
        guard let attachments = feedItem.attachments else { return [] }
        return attachments.compactMap({ (attachment) -> FeedViewModel.FeedCellPhotoAttachment? in
            guard let photo = attachment.photo else { return nil }
            return FeedViewModel.FeedCellPhotoAttachment.init(imageUrlString: photo.srcBIG,
                                                              width: photo.width,
                                                              height: photo.height)
        })
        
    }
}
