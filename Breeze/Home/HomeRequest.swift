//
//  Request.swift
//  Breeze
//
//  Created by Alex Littlejohn on 27/04/2020.
//  Copyright © 2020 zero. All rights reserved.
//

import Networking
import SwiftUI

struct HomeRequest: RequestType {
    typealias Response = HomeResponse

    let id: String

    var path: String { "group" }
}

struct HomeResponse: Codable {
    let cnt: Int
    let list: [HomeWeatherItem]
}

struct HomeWeatherItem: Codable, Hashable, Identifiable {
    let coord: Coordinates
    let sys: Sys
    let weather: [Weather]
    let main: Main
    let dt, id: Int
    let name: String
}

struct Clouds: Codable, Hashable {
    let all: Int
}

struct Sys: Codable, Hashable {
    let country: String
    let timezone, sunrise, sunset: Int
}
