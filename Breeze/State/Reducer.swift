//
//  Reducer.swift
//  Breeze
//
//  Created by Alex Littlejohn on 28/04/2020.
//  Copyright © 2020 zero. All rights reserved.
//

import Ducks
import Foundation

let reducer: Reducer<AppState> = { action, state in
    return AppState(
        speedUnits: speedUnitsReducer(action, state.speedUnits),
        temperatureUnits: temperatureUnitsReducer(action, state.temperatureUnits),
        savedLocations: savedLocationsReducer(action, state.savedLocations),
        homeState: homeStateReducer(action, state.homeState),
        searchState: searchStateReducer(action, state.searchState),
        cityState: cityStateReducer(action, state.cityState),
        tokenStorage: tokenReducer(action, state.tokenStorage)
    )
}

let speedUnitsReducer: Reducer<UnitSpeed> = { action, state in
    switch action {
    case Actions.setSpeedUnits(let value):
        return value
    case _:
        return state
    }
}

let temperatureUnitsReducer: Reducer<UnitTemperature> = { action, state in
    switch action {
    case Actions.setTemperatureUnits(let value):
        return value
    case _:
        return state
    }
}

let unitsReducer: Reducer<UnitTemperature> = { action, state in
    switch action {
    case Actions.setTemperatureUnits(let value):
        return value
    case _:
        return state
    }
}

let savedLocationsReducer: Reducer<[SavedLocation]> = { action, state in
    switch action {
    case Actions.addLocation(let value):
        return !state.contains(value) ? state.then { $0.append(value) } : state
    case Actions.removeLocation(let value):
        guard let index = state.firstIndex(of: value) else { return state }
        return state.then { $0.remove(at: index) }
    case Actions.setLocations(let value):
        return value
    case _:
        return state
    }
}

let tokenReducer: Reducer<[AnyHashable]> = { action, state in
    switch action {
    case Actions.pushToken(let token):
        return state.then { $0.append(token) }
    case Actions.popToken(let token):
        guard let index = state.firstIndex(of: token) else { return state }
        return state.then { $0.remove(at: index) }
    default:
        return state
    }
}
