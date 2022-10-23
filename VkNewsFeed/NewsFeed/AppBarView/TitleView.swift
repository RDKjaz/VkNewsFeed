//
//  AppBarView.swift
//  VkNewsFeed
//

import UIKit

/// Protocol for title view
protocol TitleViewViewModel {
    /// Url of image in string format
    var imageUrlSrting: String? { get }
}

/// Title view in app bar
class TitleView: UIView {
    
    // MARK: - Properties
    
    /// Avatar in VK
    private let avatar: WebImageView = {
        let imageView = WebImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// Label
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "VK News Feed"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        setContraints()
    }
    
    /// Set image in image view for avatar
    /// - Parameter userViewModel: ViewModel for user
    func set(userViewModel: TitleViewViewModel) {
        avatar.set(imageUrl: userViewModel.imageUrlSrting)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatar.layer.masksToBounds = true
        avatar.layer.cornerRadius = avatar.frame.width / 2
    }
}

// MARK: - Set constraints

extension TitleView {
    
    /// Set constraints and add subviews
    private func setContraints() {
        addSubview(avatar)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: self.topAnchor),
            avatar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            avatar.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            avatar.widthAnchor.constraint(equalTo: titleLabel.heightAnchor, multiplier: 1),
            avatar.heightAnchor.constraint(equalTo: titleLabel.heightAnchor, multiplier: 1),
            
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            titleLabel.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
}
