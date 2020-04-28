//
//  ViewStateView.swift
//  Breeze
//
//  Created by Alex Littlejohn on 27/04/2020.
//  Copyright © 2020 zero. All rights reserved.
//

import SwiftUI

struct ViewStateView<Content: View, P: Hashable, L: LoadingType, E: ErrorType>: View {
    
    let content: (P) -> Content
    let viewState: ViewState<P, L, E>
    
    public init(viewState: ViewState<P, L, E>, @ViewBuilder content: @escaping (P) -> Content) {
        self.content = content
        self.viewState = viewState
    }
    
    var body: some View {
        switch viewState {
        case .populated(let value):
            return AnyView(content(value))
        case .loading:
            return AnyView(LoadingView(style: .large))
        case .error(let error):
            return AnyView(ErrorView(model: error))
        }
    }
}
