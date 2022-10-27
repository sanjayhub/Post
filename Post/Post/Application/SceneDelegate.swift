//
//  SceneDelegate.swift
//  Post
//
//  Created by Kumar, Sanjay (623) on 13/09/22.
//

import UIKit
import SwiftUI
import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private var APP_ID: String { "630642f11801ec73fabed092" }
    
    private var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: .init(configuration: .ephemeral))
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = FeedUIComposer.compose(loader: makeFeedLoader)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

}

private extension SceneDelegate {
    func makeFeedLoader() -> AnyPublisher<[Feed], Error> {
        var request = URLRequest(endpoint: .feed())
        request.addValue(APP_ID, forHTTPHeaderField: "app-id")
        return httpClient
            .dispatchPublisher(for: request)
            .tryMap(FeedMapper.map)
            .dispatchOnMainQueue()
            .eraseToAnyPublisher()
        
    }
}

