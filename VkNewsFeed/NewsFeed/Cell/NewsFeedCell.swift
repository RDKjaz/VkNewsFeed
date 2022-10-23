//
//  NewsFeedCodeCell.swift
//  VkNewsFeed
//

import UIKit

/// Feed cell view model
protocol FeedCellViewModel {
    var topImageUrlString: String { get }
    var name: String { get }
    var date: String { get }
    var text: String? { get }
    var likes: String? { get }
    var comments: String? { get }
    var reposts: String? { get }
    var views: String? { get }
    var imageAttachments: [FeedCellPhotoAttachmentViewModel] { get }
    var sizes: FeedCellSizes { get }
}

protocol FeedCellPhotoAttachmentViewModel {
    var imageUrlString: String? { get }
    var width: Int { get }
    var height: Int { get }
}

protocol FeedCellSizes {
    var postLabelFrame: CGRect { get }
    var moreTextButtonFrame: CGRect { get }
    var postImageFrame: CGRect { get }
    var bottomViewFrame: CGRect { get }
    var totalHeight: CGFloat { get }
}

protocol NewsFeedCellDelegate: AnyObject {
    /// Reveal full post
    /// - Parameter cell: News feed cell
    func revealPost(for cell: NewsFeedCell)
}

final class NewsFeedCell: UITableViewCell {
    
    weak var delegate: NewsFeedCellDelegate?
    
    // MARK: - First layer
    
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Second layer
    
    let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let postLabel: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.isScrollEnabled = false
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        
        let padding = textView.textContainer.lineFragmentPadding
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: -padding)
        
        textView.dataDetectorTypes = .all
        return textView
    }()
    
    let imagesCollectionView = ImagesCollectionView()
    
    let postImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        //imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let moreTextButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.setTitleColor(.systemBlue, for: .normal)
        button.contentHorizontalAlignment = .left
        button.contentVerticalAlignment = .center
        button.setTitle("Показать полностью...", for: .normal)
        return button
    }()
    
    let bottomView: UIView = {
        let view = UIView()
        //view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Third layer
    
    let topImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let likesView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let commentsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let repostsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let viewsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Fourth layer
    
    let likesImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.image = UIImage(systemName: "heart")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let commentsImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.image = UIImage(systemName: "message")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let repostsImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.image = UIImage(systemName: "arrowshape.turn.up.left")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let viewsImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.image = UIImage(systemName: "eye")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let commentsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let repostsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let viewsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        cardView.layer.cornerRadius = 10
        cardView.clipsToBounds = true
        
        moreTextButton.addTarget(self, action: #selector(moreTextButtonTapped), for: .allTouchEvents)
        
        topImageView.layer.cornerRadius = 36 / 2
        topImageView.clipsToBounds = true
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        topImageView.set(imageUrl: nil)
        postImageView.set(imageUrl: nil)
    }
    
    @objc func moreTextButtonTapped() {
        delegate?.revealPost(for: self)
    }
        
    func set(viewModel: FeedCellViewModel) {
        topImageView.set(imageUrl: viewModel.topImageUrlString)
        nameLabel.text = viewModel.name
        dateLabel.text = viewModel.date
        postLabel.text = viewModel.text
        likesLabel.text = viewModel.likes
        commentsLabel.text = viewModel.comments
        repostsLabel.text = viewModel.reposts
        viewsLabel.text = viewModel.views
        
        postLabel.frame = viewModel.sizes.postLabelFrame
        bottomView.frame = viewModel.sizes.bottomViewFrame
        moreTextButton.frame = viewModel.sizes.moreTextButtonFrame
        
        if let imageAttachment = viewModel.imageAttachments.first, viewModel.imageAttachments.count == 1 {
            postImageView.set(imageUrl: imageAttachment.imageUrlString)
            postImageView.isHidden = false
            imagesCollectionView.isHidden = true
            postImageView.frame = viewModel.sizes.postImageFrame
        } else if viewModel.imageAttachments.count >  1 {
            imagesCollectionView.frame = viewModel.sizes.postImageFrame
            postImageView.isHidden = true
            imagesCollectionView.isHidden = false
            imagesCollectionView.set(photos: viewModel.imageAttachments)
        } else {
            postImageView.isHidden = true
            imagesCollectionView.isHidden = true
        }
    }
}

// MARK: - Set constraints and add subviews

extension NewsFeedCell {
    
    /// Set constraints
    private func setConstraints() {
        self.contentView.addSubview(cardView)
        
        cardView.addSubview(topView)
        cardView.addSubview(postLabel)
        cardView.addSubview(moreTextButton)
        cardView.addSubview(postImageView)
        cardView.addSubview(imagesCollectionView)
        cardView.addSubview(bottomView)
        
        topView.addSubview(topImageView)
        topView.addSubview(nameLabel)
        topView.addSubview(dateLabel)
        
        bottomView.addSubview(likesView)
        bottomView.addSubview(commentsView)
        bottomView.addSubview(repostsView)
        bottomView.addSubview(viewsView)
        
        likesView.addSubview(likesLabel)
        likesView.addSubview(likesImageView )
        
        commentsView.addSubview(commentsLabel)
        commentsView.addSubview(commentsImageView)
        
        repostsView.addSubview(repostsLabel)
        repostsView.addSubview(repostsImageView)
        
        viewsView.addSubview(viewsLabel)
        viewsView.addSubview(viewsImageView)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: topAnchor),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            
            topView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8),
            topView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
            topView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            topView.heightAnchor.constraint(equalToConstant: 36),
            
            topImageView.topAnchor.constraint(equalTo: topView.topAnchor),
            topImageView.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            topImageView.heightAnchor.constraint(equalToConstant: 36),
            topImageView.widthAnchor.constraint(equalToConstant: 36),
            
            nameLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: 2),
            nameLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -8),
            nameLabel.leadingAnchor.constraint(equalTo: topImageView.trailingAnchor, constant: 8),
            nameLabel.heightAnchor.constraint(equalToConstant: 16),
            
            dateLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -8),
            dateLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -2),
            dateLabel.leadingAnchor.constraint(equalTo: topImageView.trailingAnchor, constant: 8),
            dateLabel.heightAnchor.constraint(equalToConstant: 14),
            
            likesView.topAnchor.constraint(equalTo: bottomView.topAnchor),
            likesView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            likesView.widthAnchor.constraint(equalToConstant: 80),
            likesView.heightAnchor.constraint(equalToConstant: 44),
            
            commentsView.topAnchor.constraint(equalTo: bottomView.topAnchor),
            commentsView.leadingAnchor.constraint(equalTo: likesView.trailingAnchor),
            commentsView.widthAnchor.constraint(equalToConstant: 80),
            commentsView.heightAnchor.constraint(equalToConstant: 44),
            
            repostsView.topAnchor.constraint(equalTo: bottomView.topAnchor),
            repostsView.leadingAnchor.constraint(equalTo: commentsView.trailingAnchor),
            repostsView.widthAnchor.constraint(equalToConstant: 80),
            repostsView.heightAnchor.constraint(equalToConstant: 44),
            
            viewsView.topAnchor.constraint(equalTo: bottomView.topAnchor),
            viewsView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            viewsView.widthAnchor.constraint(equalToConstant: 80),
            viewsView.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        setContstraintForBottomViewElements(view: likesView, imageView: likesImageView, label: likesLabel)
        setContstraintForBottomViewElements(view: commentsView, imageView: commentsImageView, label: commentsLabel)
        setContstraintForBottomViewElements(view: repostsView, imageView: repostsImageView, label: repostsLabel)
        setContstraintForBottomViewElements(view: viewsView, imageView: viewsImageView, label: viewsLabel)
    }
    
    /// Set constraints for elements in views in bottom view
    private func setContstraintForBottomViewElements(view: UIView, imageView: UIImageView, label: UILabel) {
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24),
            
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
