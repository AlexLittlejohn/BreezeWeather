//
//  ErrorView.swift
//  Breeze
//
//  Created by Alex Littlejohn on 27/04/2020.
//  Copyright © 2020 zero. All rights reserved.
//

import SwiftUI

struct ErrorView<T: ErrorType>: View {
    
    var model: T
    
    var body: some View {
        VStack(alignment: .leading, spacing: Measurements.small) {
            if !model.message.isEmpty {
                Text(model.message)
                    .font(Font.system(size: 14, weight: .medium))
                    .foregroundColor(Color(.secondaryLabel))
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    
            }

            button
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding(.horizontal, model.message.isEmpty ? 0 : Measurements.larger)
        .padding(.vertical, model.message.isEmpty ? 0 : Measurements.medium)
    }
    
    var button: some View {
        switch model.button {
        case .none:
            return AnyView(EmptyView())
        case let .button(actionTitle, action):
            return AnyView(Button(action: action, label: { Text(actionTitle) }).buttonStyle(PrimaryButtonStyle()))
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        
        let error = ViewStateError(message: "Enable location services to show suggestions for nearby towns and cities", button: .button(actionTitle: "Enable", action: {}))
        
        return ErrorView(model: error)
    }
}
