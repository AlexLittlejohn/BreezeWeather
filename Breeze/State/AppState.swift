//
//  AppState.swift
//  Breeze
//
//  Created by Alex Littlejohn on 26/04/2020.
//  Copyright © 2020 zero. All rights reserved.
//

import Ducks
import Foundation

struct AppState: StateType {
    let speedUnits: UnitSpeed
    let temperatureUnits: UnitTemperature
    let savedLocations: [SavedLocation]
    
    let homeState: HomeState
    let searchState: SearchState
    let cityState: CityState

    let tokenStorage: [AnyHashable]
    
    static let empty = AppState(speedUnits: .kilometersPerHour, temperatureUnits: .celsius, savedLocations: [], homeState: .empty, searchState: .empty, cityState: .empty, tokenStorage: [])
}
