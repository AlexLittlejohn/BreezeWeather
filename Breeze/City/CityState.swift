//
//  CityState.swift
//  Breeze
//
//  Created by Alex Littlejohn on 28/04/2020.
//  Copyright © 2020 zero. All rights reserved.
//

import Ducks
import SwiftUI

typealias CityViewState = ViewState<CityWeather, ViewStateLoading, ViewStateError>

struct CityState {
    let selectedLocation: HomeItemModel
    let viewState: CityViewState
    
    static let empty = CityState(selectedLocation: .empty, viewState: .error(.empty))
}

struct CityWeather: Hashable {
    let time: String
    let weatherIcon: String?
    let weatherDescription: String
    let sunrise, sunset, temp, feelsLike, windSpeed, windDeg, dewPoint, clouds, pressure, humidity: String
    let hourly: [HourWeather]
    let daily: [DayWeather]
    
    static let empty = CityWeather(time: "", weatherIcon: nil, weatherDescription: "", sunrise: "", sunset: "", temp: "", feelsLike: "", windSpeed: "", windDeg: "", dewPoint: "", clouds: "", pressure: "", humidity: "", hourly: [], daily: [])
}

struct DayWeather: Hashable, Identifiable {
    var id = UUID()
    let weatherIcon: String?
    let time: String
    let high: String
    let low: String
}

struct HourWeather: Hashable, Identifiable {
    var id = UUID()
    let weatherIcon: String?
    let time: String
    let temperature: String
}

let cityStateReducer: Reducer<CityState> = { action, state in
    return CityState(
        selectedLocation: selectedLocationReducer(action, state.selectedLocation),
        viewState: cityViewStateReducer(action, state.viewState)
    )
}

let selectedLocationReducer: Reducer<HomeItemModel> = { action, state in
    switch action {
    case Actions.setSelectedLocation(let value):
        return value
    case _:
        return state
    }
}

let cityViewStateReducer: Reducer<CityViewState> = { action, state in
    switch action {
    case Actions.setCityViewState(let value):
        return value
    case _:
        return state
    }
}

let cityMiddleware: Middleware<AppState> = { store, next, action in

    switch action {
    case Actions.fetchSelectedLocation:
        
        let units = store.state.temperatureUnits
        let speed = store.state.speedUnits
        let location = store.state.cityState.selectedLocation
        let request = CityRequest(lat: location.coord.lat, lon: location.coord.lon)
        let token = make(request: request).sink(receiveCompletion: { value in
            switch value {
            case .failure:
                let error = ViewStateError(message: "Unable to fetch data for this location. Please try again in a few minutes...", button: .button(actionTitle: "Retry", action: { store.dispatch(Actions.fetchSelectedLocation) }))
                store.dispatch(Actions.setCityViewState(.error(error)))
            case _:
                break
            }
        }, receiveValue: { value in
            
            let hours: [HourWeather] = value.hourly.compactMap { item in
                guard let weather = item.weather.first else { return nil }
                return HourWeather(
                    weatherIcon: weatherIdToImage(weather.id, night: weather.icon.hasSuffix("n")),
                    time: hourlyTime(timezone: value.timezone, time: item.dt),
                    temperature: formatted(kelvin: item.temp, in: units)
                )
            }
            
            let daily: [DayWeather] = value.daily.compactMap { item in
                guard let weather = item.weather.first else { return nil }
                return DayWeather(
                    weatherIcon: weatherIdToImage(weather.id, night: weather.icon.hasSuffix("n")),
                    time: dayTime(timezone: value.timezone, time: item.dt),
                    high: formatted(kelvin: item.temp.max, in: units),
                    low: formatted(kelvin: item.temp.min, in: units)
                )
            }
            
            
            let icon: String
            let weatherDescription: String

            if let weather = value.current.weather.first {
                icon = weatherIdToImage(weather.id, night: weather.icon.hasSuffix("n")) ?? ""
                weatherDescription = weather.weatherDescription
            } else {
                icon = ""
                weatherDescription = ""
            }
            
            let cityWeather = CityWeather(
                time: formatted(timezone: value.timezone),
                weatherIcon: icon,
                weatherDescription: weatherDescription,
                sunrise: mediumHourlyTime(timezone: value.timezone, time: value.current.sunrise),
                sunset: mediumHourlyTime(timezone: value.timezone, time: value.current.sunset),
                temp: formatted(kelvin: value.current.temp, in: units),
                feelsLike: formatted(kelvin: value.current.feelsLike, in: units),
                windSpeed: formatted(meters: value.current.windSpeed, in: speed),
                windDeg: formatted(degrees: value.current.windDeg),
                dewPoint: formatted(kelvin: value.current.feelsLike, in: units),
                clouds: formatted(percentage: value.current.clouds),
                pressure: formatted(pressure: value.current.pressure),
                humidity: formatted(percentage: value.current.humidity),
                hourly: hours,
                daily: daily
            )

            store.dispatch(Actions.setCityViewState(.populated(cityWeather)))
        })
        
        store.dispatch(Actions.setCityViewState(.loading(.loading)))
        store.dispatch(Actions.pushToken(token))
    default:
        break
    }
    
    next(action)
}
