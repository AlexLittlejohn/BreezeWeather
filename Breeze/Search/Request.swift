//
//  Request.swift
//  Breeze
//
//  Created by Alex Littlejohn on 26/04/2020.
//  Copyright © 2020 zero. All rights reserved.
//

import Networking

struct MiniWeatherRequest: RequestType {
    typealias Response = MiniWeatherResponse
    
    let lat: Double
    let lon: Double
    var path: String { "weather" }
}

struct MiniWeatherResponse: Codable {
    let coord: Coordinates
    let id: Int
    let name: String
}

// example url http://api.openweathermap.org/data/2.5/find?lat=55.5&lon=37.5&cnt=10
/// Request nearby locations around a lat lon
struct NearbyLocationsRequest: RequestType {
    typealias Response = NearbyLocationsResponse
    
    let lat: Double
    let lon: Double
    let cnt: Int

    var path: String { "find" }
}

struct NearbyLocationsResponse: Codable {
    let count: Int
    let list: [NearbyLocations]
}

struct NearbyLocations: Codable {
    let id: Int
    let name: String
    let coord: Coordinates
    let main: Main
    let weather: [Weather]
}

struct Coordinates: Hashable, Codable {
    let lat, lon: Double
}

struct Main: Codable, Hashable {
    let temp, feelsLike, low, high, pressure, humidity: Double

    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case feelsLike = "feels_like"
        case low = "temp_min"
        case high = "temp_max"
    }
}

struct Weather: Codable, Hashable {
    let id: Int
    let main: String
    let weatherDescription: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case id, main, icon
        case weatherDescription = "description"
    }
}
