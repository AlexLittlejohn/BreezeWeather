//
//  SearchState.swift
//  Breeze
//
//  Created by Alex Littlejohn on 27/04/2020.
//  Copyright © 2020 zero. All rights reserved.
//

import Ducks

typealias SearchViewState = ViewState<[SearchResultModel], ViewStateLoading, ViewStateError>
typealias NearbyViewState = ViewState<[NearbyItemModel], ViewStateLoading, ViewStateError>

struct SearchState {
    let searchViewState: SearchViewState
    let nearbyViewState: NearbyViewState
    let query: String
    
    static let empty = SearchState(searchViewState: .error(.empty), nearbyViewState: .error(.empty), query: "")
}

let searchStateReducer: Reducer<SearchState> = { action, state in
    return SearchState(
        searchViewState: searchViewStateReducer(action, state.searchViewState),
        nearbyViewState: nearbyViewStateReducer(action, state.nearbyViewState),
        query: queryReducer(action, state.query)
    )
}

let searchViewStateReducer: Reducer<SearchViewState> = { action, state in
    switch action {
    case Actions.setSearchViewState(let value):
        return value
    case _:
        return state
    }
}

let nearbyViewStateReducer: Reducer<NearbyViewState> = { action, state in
    switch action {
    case Actions.setNearbyViewState(let value):
        return value
    case _:
        return state
    }
}

let queryReducer: Reducer<String> = { action, state in
    switch action {
    case Actions.setQuery(let value):
        return value
    case _:
        return state
    }
}
