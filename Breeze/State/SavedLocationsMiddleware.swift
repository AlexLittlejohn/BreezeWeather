//
//  SavedLocationsMiddleware.swift
//  Breeze
//
//  Created by Alex Littlejohn on 28/04/2020.
//  Copyright © 2020 zero. All rights reserved.
//

import Ducks

let savedLocationsMiddleware: Middleware<AppState> = { store, next, action in

    switch action {
    case Actions.addLocation(let location):
        LocationStorage.shared.add(location: location)
    case Actions.removeLocation(let location):
        LocationStorage.shared.remove(location: location)
    default:
        break
    }
    
    next(action)
}
