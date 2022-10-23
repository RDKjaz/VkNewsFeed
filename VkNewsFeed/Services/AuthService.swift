//
//  AuthService.swift
//  VkNewsFeed
//

import Foundation
import VK_ios_sdk

/// Protocol for authorization service (delegate)
protocol AuthServiceDelegate: AnyObject {
    /// Should show controller
    /// - Parameter controller: ViewController
    func shouldShow(controller: UIViewController)
    /// Sign in
    func signIn()
    /// Sign in with fail
    func signInDidFail()
}

/// Authorization service
class AuthService: NSObject, VKSdkDelegate, VKSdkUIDelegate {

    // MARK: - Properties
    
    /// Application ID
    private let appId = ""
    private let vkSdk: VKSdk
    
    weak var delegate: AuthServiceDelegate?
    
    /// Access token
    var token: String? {
        return VKSdk.accessToken()?.accessToken
    }
    
    /// Id of user
    var userId: String? {
        return VKSdk.accessToken()?.userId
    }

    // MARK: - Methods
    
    override init() {
        vkSdk = VKSdk.initialize(withAppId: appId)
        super.init()
        vkSdk.register(self)
        vkSdk.uiDelegate = self
    }

    /// Create new session
    func wakeUpSession() {
        let scope = ["wall", "friends"]
        VKSdk.wakeUpSession(scope) { [delegate] state, _ in
            switch state {
            case .initialized:
                VKSdk.authorize(scope)
            case .authorized:
                delegate?.signIn()
            default:
                delegate?.signInDidFail()
            }
        }
    }

    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        print(#function)
        if result.token != nil {
            delegate?.signIn()
        }
    }

    func vkSdkUserAuthorizationFailed() {
        print(#function)
        delegate?.signInDidFail()
    }

    func vkSdkShouldPresent(_ controller: UIViewController!) {
        delegate?.shouldShow(controller: controller)
    }

    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print(#function)
    }
}
