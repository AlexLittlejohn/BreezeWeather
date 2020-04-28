//
//  NearbyItemView.swift
//  Breeze
//
//  Created by Alex Littlejohn on 26/04/2020.
//  Copyright © 2020 zero. All rights reserved.
//

import SwiftUI

struct NearbyItemView: View {
    
    var model: NearbyItemModel
    var action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            VStack(alignment: .leading, spacing: 8) {
                Text(model.name)
                    .font(Font.system(size: 16, weight: .light))
                    .foregroundColor(Color(.label))
                    .lineLimit(nil)

                Spacer()
                
                HStack {
                    Text(model.formattedTemperature)
                        .font(Font.system(size: 36, weight: .heavy))
                        .foregroundColor(Color(.label))
                    
                    Spacer()
                    
                    Image(systemName: model.weatherIcon ?? "")
                        .foregroundColor(Color(.systemBlue))
                }
            }
        })
        .buttonStyle(CardButtonStyle())
        .aspectRatio(1, contentMode: .fit)
    }
}

struct NearbyItemView_Previews: PreviewProvider {
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
