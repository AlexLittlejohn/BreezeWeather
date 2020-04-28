//
//  Models.swift
//  Breeze
//
//  Created by Alex Littlejohn on 26/04/2020.
//  Copyright © 2020 zero. All rights reserved.
//

import SwiftUI
import MapKit

struct SearchResultModel: Hashable, Identifiable {
    var id = UUID()
    let result: MKLocalSearchCompletion
}

struct NearbyItemModel: Hashable, Identifiable {
    let id: String
    let name: String
    let formattedTemperature: String
    let weatherDescription: String
    let weatherIcon: String?
    let coord: Coordinates
}
