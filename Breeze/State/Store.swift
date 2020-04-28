//
//  State+Environment.swift
//  Breeze
//
//  Created by Alex Littlejohn on 27/04/2020.
//  Copyright © 2020 zero. All rights reserved.
//

import Combine
import Ducks
import SwiftUI

let store = Store(reducer: reducer, state: AppState.empty, middleware: [searchMiddleware, nearbyMiddleware, homeMiddleware, savedLocationsMiddleware, cityMiddleware])

struct AppStateEnvironment: EnvironmentKey {
    let appState: CurrentValueSubject<AppState, Never>
    
    static var defaultValue: Self {
        return .init(appState: .init(store.state))
    }
}

struct StoreEnvironment: EnvironmentKey {
    let dispatch: (Action) -> Void
    
    static var defaultValue: Self {
        return .init(dispatch: store.dispatch)
    }
}

extension EnvironmentValues {
    var state: AppStateEnvironment {
        get { self[AppStateEnvironment.self] }
        set { self[AppStateEnvironment.self] = newValue }
    }
    
    var dispatch: StoreEnvironment {
        get { self[StoreEnvironment.self] }
        set { self[StoreEnvironment.self] = newValue }
    }
}
