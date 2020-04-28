//
//  ViewState.swift
//  Breeze
//
//  Created by Alex Littlejohn on 27/04/2020.
//  Copyright © 2020 zero. All rights reserved.
//

enum ViewState<P: Hashable, L: LoadingType, E: ErrorType>: Hashable {
    case populated(P)
    case loading(L)
    case error(E)
}

enum ButtonState: Hashable {
    case none
    case button(actionTitle: String, action: () -> Void)
    
    static func == (lhs: ButtonState, rhs: ButtonState) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none):
            return true
        case let (.button(t1, _), .button(t2, _)):
            return t1 == t2
        case _:
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .none:
            break
        case let .button(title, _):
            hasher.combine(title)
        }
    }
}

protocol ErrorType: Hashable {
    var message: String { get }
    var button: ButtonState { get }
}

protocol LoadingType: Hashable {
    var message: String { get }
}

struct ViewStateError: ErrorType {
    let message: String
    let button: ButtonState
    
    static let empty = ViewStateError(message: "", button: .none)
}

struct ViewStateLoading: LoadingType {
    let message: String
    
    static let loading = ViewStateLoading(message: "Loading...")
    static let saving = ViewStateLoading(message: "Saving...")
}


