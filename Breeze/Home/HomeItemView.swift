//
//  HomeItemView.swift
//  Breeze
//
//  Created by Alex Littlejohn on 27/04/2020.
//  Copyright © 2020 zero. All rights reserved.
//

import SwiftUI

struct HomeItemModel: Hashable, Identifiable {
    let id: String
    let name: String
    let formattedTemperature: String
    let weatherIcon: String?
    let formattedTime: String
    let coord: Coordinates
    
    static let empty = HomeItemModel(id: "", name: "", formattedTemperature: "", weatherIcon: nil, formattedTime: "", coord: Coordinates(lat: 0, lon: 0))
}

struct HomeItemView: View {
    
    var model: HomeItemModel
    var action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            VStack(alignment: .leading, spacing: 4) {
                Text(model.name)
                    .font(Font.system(size: 24, weight: .light))
                    .foregroundColor(Color(.label))
                
                Text(model.formattedTime)
                    .font(Font.system(size: 16, weight: .light))
                    .foregroundColor(Color(.secondaryLabel))

                Spacer()
                
                HStack(alignment: .firstTextBaseline) {
                    Text(model.formattedTemperature)
                        .font(Font.system(size: 48, weight: .heavy))
                        .foregroundColor(Color(.label))
                    
                    Spacer()
                    
                    Image(systemName: model.weatherIcon ?? "")
                        .font(Font.system(size: 32, weight: .medium))
                        .frame(width: 32, height: 32)
                        .foregroundColor(Color(.systemBlue))
                }
            }
        })
        .buttonStyle(CardButtonStyle())
        .contextMenu(ContextMenu(menuItems: {
            Button(action: {
                store.dispatch(Actions.deleteLocation(self.model))
            }, label: {
                HStack {
                    Text("Delete")
                    Image(systemName: "trash")
                }.foregroundColor(.red)
            })
        }))
        .aspectRatio(1.35, contentMode: .fit)
        .padding(.horizontal, Measurements.large)
        .padding(.vertical, Measurements.small)
    }
}

struct HomeItemView_Previews: PreviewProvider {
    static var previews: some View {
        
        let model = NearbyItemModel(
            id: "",
            name: "Helsinki, Finland",
            formattedTemperature: "54•",
            weatherDescription: "light rain",
            weatherIcon: "cloud.heavyrain",
            coord: Coordinates(lat: 0, lon: 0)
        )
        
        return NearbyItemView(model: model, action: { }).frame(width: 144, height: 144)
    }
}
