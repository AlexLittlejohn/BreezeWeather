//
//  SearchMiddleware.swift
//  Breeze
//
//  Created by Alex Littlejohn on 27/04/2020.
//  Copyright © 2020 zero. All rights reserved.
//

import Ducks

let searchMiddleware: Middleware<AppState> = { store, next, action in
    
    func makeErrorState(with action: @escaping () -> Void) -> ViewStateError {
        ViewStateError(
            message: "Something went wrong while trying to complete your query...",
            button: .button(actionTitle: "Retry", action: action)
        )
    }
    
    switch action {
    case Actions.setQuery(let query):
        
        guard !query.isEmpty else {
            store.dispatch(Actions.setSearchViewState(.error(.empty)))
            return next(action)
        }
        
        let helper = LocalSearchHelper()
        
        let token = helper.publisher.sink(receiveCompletion: { value in
            switch value {
            case .failure:
                let error = makeErrorState(with: { store.dispatch(Actions.setQuery(query)) })
                store.dispatch(Actions.setSearchViewState(.error(error)))
                store.dispatch(Actions.popToken(helper))
            case _:
                break
            }
        }, receiveValue: { value in
            let results = value.map { SearchResultModel(result: $0) }
            store.dispatch(Actions.setSearchViewState(.populated(results)))
            store.dispatch(Actions.popToken(helper))
        })
        
        helper.setQuery(query)
        
        store.dispatch(Actions.pushToken(helper))
        store.dispatch(Actions.pushToken(token))
        
        next(action)
    case Actions.fetchDataForResult(let result):
        
        let search = LocalSearchHelper.makeSearch(for: result.result)
        let token = LocalSearchHelper.publisher(for: search).sink(receiveCompletion: { value in
            
            switch value {
            case .failure:
                let error = makeErrorState(with: { store.dispatch(Actions.fetchDataForResult(result)) })
                store.dispatch(Actions.setSearchViewState(.error(error)))
                store.dispatch(Actions.popToken(search))
            case _:
                break
            }
            
        }, receiveValue: { value in
            store.dispatch(Actions.fetchWeatherIDForCoordinates(lat: value.latitude, lon: value.longitude))
            store.dispatch(Actions.popToken(search))
        })
        
        store.dispatch(Actions.pushToken(token))
        store.dispatch(Actions.pushToken(search))
        store.dispatch(Actions.setSearchViewState(.loading(.loading)))
    case Actions.fetchWeatherIDForCoordinates(let latitude, let longitude):
            
        let request = MiniWeatherRequest(lat: latitude, lon: longitude)

        let token = make(request: request).sink(receiveCompletion: { completion in
            let error = makeErrorState(with: { store.dispatch(Actions.fetchWeatherIDForCoordinates(lat: latitude, lon: longitude)) })
            store.dispatch(Actions.setSearchViewState(.error(error)))
        }, receiveValue: { data in
            let location = SavedLocation(id: "\(data.id)", name: data.name, coord: Coordinates(lat: latitude, lon: longitude))
            store.dispatch(Actions.addLocation(location))
            store.dispatch(Actions.setQuery(""))
            store.dispatch(Actions.hideSearch)
            store.dispatch(Actions.fetchHomeWeather)
        })
        
        store.dispatch(Actions.setSearchViewState(.loading(.loading)))
        store.dispatch(Actions.pushToken(token))
    default:
        next(action)
    }
}
