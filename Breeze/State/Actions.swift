//
//  Actions.swift
//  Breeze
//
//  Created by Alex Littlejohn on 27/04/2020.
//  Copyright © 2020 zero. All rights reserved.
//

import Combine
import Ducks
import CoreLocation
import Foundation

enum Actions: Action {
    
    case setSpeedUnits(UnitSpeed)
    case setTemperatureUnits(UnitTemperature)

    case addLocation(SavedLocation)
    case removeLocation(SavedLocation)
    case setLocations([SavedLocation])
    case setQuery(String)
    
    case pushToken(AnyHashable)
    case popToken(AnyHashable)
    
    case fetchHomeWeather

    case requestLocationServices
    case fetchLocation
    case fetchWeatherAround(CLLocation)
    case fetchSaved
    case deleteLocation(HomeItemModel)
    case bookmarkLocation(NearbyItemModel)
    case fetchDataForResult(SearchResultModel)
    case fetchWeatherIDForCoordinates(lat: Double, lon: Double)

    case showSearch
    case hideSearch
    case setIsSearchShowing(Bool)

    case setSelectedLocation(HomeItemModel)
    case fetchSelectedLocation

    case setHomeViewState(HomeViewState)
    case setSearchViewState(SearchViewState)
    case setNearbyViewState(NearbyViewState)
    case setCityViewState(CityViewState)
}

