//
//  CityRequest.swift
//  Breeze
//
//  Created by Alex Littlejohn on 28/04/2020.
//  Copyright © 2020 zero. All rights reserved.
//

import Networking

struct CityRequest: RequestType {
    typealias Response = CityResponse
    
    let lat: Double
    let lon: Double
    var path: String { "onecall" }
}

struct CityResponse: Codable, Hashable {
    let lat, lon: Double
    let timezone: String
    let current: TodayResponse
    let hourly: [HourlyResponse]
    let daily: [Daily]
}

struct TodayResponse: Codable, Hashable {
    let dt, sunrise, sunset, temp, feelsLike: Double
    let pressure, humidity: Double
    let dewPoint, uvi: Double
    let clouds: Double
    let windSpeed: Double
    let windDeg: Double
    let weather: [Weather]

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather
    }
}

// MARK: - Current
struct HourlyResponse: Codable, Hashable {
    let dt, temp, feelsLike: Double
    let pressure, humidity: Int
    let dewPoint: Double
    let clouds: Int
    let windSpeed: Double
    let windDeg: Int
    let weather: [Weather]

    enum CodingKeys: String, CodingKey {
        case dt, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case clouds
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather
    }
}

// MARK: - Daily
struct Daily: Codable, Hashable {
    let dt, sunrise, sunset: Double
    let temp: Temp
    let feelsLike: FeelsLike
    let pressure, humidity: Int
    let dewPoint, windSpeed: Double
    let windDeg: Int
    let weather: [Weather]
    let clouds: Int
    let uvi: Double
    let snow, rain: Double?

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather, clouds, uvi, snow, rain
    }
}

// MARK: - FeelsLike
struct FeelsLike: Codable, Hashable {
    let day, night, eve, morn: Double
}

// MARK: - Temp
struct Temp: Codable, Hashable {
    let day, min, max, night, eve, morn: Double
}
