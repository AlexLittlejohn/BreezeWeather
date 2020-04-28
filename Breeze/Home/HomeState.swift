//
//  HomeState.swift
//  Breeze
//
//  Created by Alex Littlejohn on 27/04/2020.
//  Copyright © 2020 zero. All rights reserved.
//

import Foundation
import Ducks

typealias HomeViewState = ViewState<[HomeItemModel], ViewStateLoading, ViewStateError>

struct HomeState {
    let isSearchShowing: Bool
    let viewState: HomeViewState
    
    static let empty = HomeState(isSearchShowing: false, viewState: .error(.empty))
}

let homeStateReducer: Reducer<HomeState> = { action, state in
    return HomeState(
        isSearchShowing: isSearchShowingReducer(action, state.isSearchShowing),
        viewState: homeViewStateReducer(action, state.viewState)
    )
}

let isSearchShowingReducer: Reducer<Bool> = { action, state in
    switch action {
    case Actions.showSearch:
        return true
    case Actions.hideSearch:
        return false
    case Actions.setIsSearchShowing(let value):
        return value
    default:
        return state
    }
}

let homeViewStateReducer: Reducer<HomeViewState> = { action, state in
    switch action {
    case Actions.setHomeViewState(let value):
        return value
    case Actions.deleteLocation(let value):
        guard case let .populated(current) = state, let index = current.firstIndex(of: value) else { return state }
        return .populated(current.then { $0.remove(at: index) })
    case _:
        return state
    }
}

let homeMiddleware: Middleware<AppState> = { store, next, action in

    let error = ViewStateError(message: "You haven't added any locations. Use the search function to add new locations", button: .button(actionTitle: "Add location", action: { store.dispatch(Actions.showSearch) }))
    
    switch action {
    case Actions.deleteLocation(let location):
        
        guard let saved = store.state.savedLocations.first(where: { $0.id == location.id }) else { return next(action) }
        store.dispatch(Actions.removeLocation(saved))
        
        if store.state.savedLocations.count == 0 {
            store.dispatch(Actions.setHomeViewState(.error(error)))
        }
        
        next(action)
    case Actions.fetchHomeWeather:

        guard !store.state.savedLocations.isEmpty else {
            store.dispatch(Actions.setHomeViewState(.error(error)))
            return
        }
        
        let id = store.state.savedLocations.map { $0.id }.joined(separator: ",")
        let request = HomeRequest(id: id)

        let token = make(request: request).sink(receiveCompletion: { value in
            switch value {
            case .failure(let e):
                let error = ViewStateError(message: "Unable to fetch weather data for your bookmarked locations, please retry again in a few minutes", button: .button(actionTitle: "Retry", action: { store.dispatch(Actions.fetchHomeWeather) }))
                store.dispatch(Actions.setHomeViewState(.error(error)))
            case _:
                break
            }
        }, receiveValue: { data in
            
            let items: [HomeItemModel] = data.list.compactMap { item in
                guard let weather = item.weather.first else { return nil }
                
                return HomeItemModel(
                    id: "\(item.id)",
                    name: item.name,
                    formattedTemperature: formatted(kelvin: item.main.temp, in: store.state.temperatureUnits),
                    weatherIcon: weatherIdToImage(
                        weather.id,
                        // this is the simplest (hacky) way to check if its nighttime for the icons we want to switch
                        night: weather.icon.hasSuffix("n")
                    ),
                    formattedTime: formatted(timezone: item.sys.timezone),
                    coord: item.coord
                )
            }
            
            store.dispatch(Actions.setHomeViewState(.populated(items)))
        })

        store.dispatch(Actions.setHomeViewState(.loading(.loading)))
        store.dispatch(Actions.pushToken(token))
    default:
        next(action)
    }
}
