//
//  ViewController.swift
//  VkNewsFeed
//
//  Created by Radik Gazetdinov on 12.09.2022.
//

import UIKit
import VK_ios_sdk

/// Authorization ViewController
class AuthViewController: UIViewController {

    // MARK: - Properties
    
    /// Authorization service
    private var authService: AuthService!

    /// Log in button
    let authButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray5
        button.titleLabel?.font = button.titleLabel?.font.withSize(26)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(authTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        authService = SceneDelegate.shared().authService
        setConstraints()
    }

    /// Handle authButton by tapped
    @objc func authTapped() {
        authService.wakeUpSession()
    }
}

// MARK: - Set constraints
extension AuthViewController {

    /// Set constraints
    func setConstraints() {
        view.addSubview(authButton)
        NSLayoutConstraint.activate([
            authButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            authButton.heightAnchor.constraint(equalToConstant: 50),
            authButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
}
