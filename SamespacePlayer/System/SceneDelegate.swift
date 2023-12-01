//
//  SceneDelegate.swift
//  SamespacePlayer
//
//  Created by Shreyansh Mishra on 24/11/23.
//

import Foundation
import UIKit
import SwiftUI

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let environment = AppEnvironment.bootstrap()
        let appView = SamespacePlayerApp(container: environment.container)
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: appView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
