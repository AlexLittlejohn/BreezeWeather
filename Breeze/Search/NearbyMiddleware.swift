//
//  NearbyMiddleware.swift
//  Breeze
//
//  Created by Alex Littlejohn on 27/04/2020.
//  Copyright © 2020 zero. All rights reserved.
//

import Ducks
import Foundation

let nearbyMiddleware: Middleware<AppState> = { store, next, action in
    switch action {
    case Actions.fetchLocation:
        
        let helper = CurrentLocationHelper()
        
        guard helper.canFetchLocation() else { return }
        
        let token = helper.publisher.receive(on: RunLoop.main).sink(receiveCompletion: { value in
            
            switch value {
            case .failure:
                let error = ViewStateError(message: "Enable location services to show suggestions for nearby towns and cities", button: .button(actionTitle: "Retry", action: { store.dispatch(Actions.fetchLocation) }))
                store.dispatch(Actions.setNearbyViewState(.error(error)))
            case _:
                break
            }
            
            store.dispatch(Actions.popToken(helper))
        }, receiveValue: { value in
            store.dispatch(Actions.fetchWeatherAround(value))
            store.dispatch(Actions.popToken(helper))
        })
        
        helper.requestLocationServices()
        
        store.dispatch(Actions.pushToken(helper))
        store.dispatch(Actions.pushToken(token))
        store.dispatch(Actions.setNearbyViewState(.loading(.loading)))
    case Actions.requestLocationServices:
        
        let helper = CurrentLocationHelper()
        
        let token = helper.publisher.receive(on: RunLoop.main).sink(receiveCompletion: { value in
            
            switch value {
            case .failure:
                let error = ViewStateError(message: "Enable location services to show suggestions for nearby towns and cities", button: .button(actionTitle: "Retry", action: { store.dispatch(Actions.fetchLocation) }))
                store.dispatch(Actions.setNearbyViewState(.error(error)))
            case _:
                break
            }
            
            store.dispatch(Actions.popToken(helper))
        }, receiveValue: { value in
            store.dispatch(Actions.fetchWeatherAround(value))
            store.dispatch(Actions.popToken(helper))
        })
        
        helper.requestLocation()
        
        store.dispatch(Actions.pushToken(helper))
        store.dispatch(Actions.pushToken(token))
        store.dispatch(Actions.setNearbyViewState(.loading(.loading)))
    case Actions.fetchWeatherAround(let location):
        
        let units = store.state.temperatureUnits
        let request = NearbyLocationsRequest(lat: location.coordinate.latitude, lon: location.coordinate.longitude, cnt: 8)
        
        let token = make(request: request).sink(receiveCompletion: { (value) in
            
            switch value {
            case .failure:
                let error = ViewStateError(
                    message: "Something went wrong while trying to fetch nearby locations. You can try again if your network conditions change",
                    button: .button(actionTitle: "Retry", action: {
                        store.dispatch(Actions.fetchWeatherAround(location))
                    })
                )
                store.dispatch(Actions.setNearbyViewState(.error(error)))
            case _:
                break
            }
            
        }, receiveValue: { (value) in
            let processed: [NearbyItemModel] = value.list.compactMap { item in
                guard let weather = item.weather.first else { return nil }
                
                return NearbyItemModel(
                    id: "\(item.id)",
                    name: item.name,
                    formattedTemperature: formatted(kelvin: item.main.temp, in: units),
                    weatherDescription: weather.weatherDescription,
                    weatherIcon: weatherIdToImage(
                        weather.id,
                        // this is the simplest (hacky) way to check if its nighttime for the icons we want to switch
                        night: weather.icon.hasSuffix("n")
                    ),
                    coord: item.coord
                )
            }
            
            store.dispatch(Actions.setNearbyViewState(.populated(processed)))
        })
        
        store.dispatch(Actions.setNearbyViewState(.loading(.loading)))
        store.dispatch(Actions.pushToken(token))
    case Actions.bookmarkLocation(let location):

        let item = SavedLocation(id: location.id, name: location.name, coord: location.coord)
        store.dispatch(Actions.addLocation(item))
        store.dispatch(Actions.fetchHomeWeather)
    default:
        next(action)
    }
}


