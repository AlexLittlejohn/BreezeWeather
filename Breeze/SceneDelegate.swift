//
//  SceneDelegate.swift
//  Breeze
//
//  Created by Alex Littlejohn on 26/04/2020.
//  Copyright © 2020 zero. All rights reserved.
//

import Ducks
import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        let contentView = HomeView()
            .environment(\.state, AppStateEnvironment(appState: .init(store.state)))
            .environment(\.dispatch, StoreEnvironment(dispatch: store.dispatch))

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        LocationStorage.shared.sync()
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        LocationStorage.shared.getAllLocationsFromCache()
        store.dispatch(Actions.setLocations(LocationStorage.shared.savedLocations))
    }
}

