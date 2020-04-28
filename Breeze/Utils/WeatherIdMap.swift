//
//  WeatherIdMap.swift
//  Breeze
//
//  Created by Alex Littlejohn on 26/04/2020.
//  Copyright © 2020 zero. All rights reserved.
//

/// Custom mapping from condition codes to SF Symbols - https://openweathermap.org/weather-conditions
func weatherIdToImage(_ id: Int, night: Bool) -> String? {
    switch id {
    case 200...202, 230...232:
        return "cloud.bolt.rain"
    case 210...221:
        return "cloud.bolt"
    case 300...399:
        return "cloud.drizzle"
    case 500...504, 520...531:
        return "cloud.heavyrain"
    case 511:
        return "cloud.hail"
    case 600...602, 615...622:
        return "snow"
    case 611...613:
        return "cloud.sleet"
    case 701:
        return "smoke"
    case 711:
        return "smoke"
    case 721:
        return "sun.haze"
    case 731:
        return "sun.dust"
    case 741:
        return "cloud.fog"
    case 751:
        return "sun.dust"
    case 761:
        return "sun.dust"
    case 762:
        return "flame"
    case 771:
        return "wind.snow"
    case 781:
        return "tornado"
    case 800:
        return night ? "moon" : "sun.min"
    case 801...803:
        return night ? "cloud.moon" : "cloud.sun"
    case 803...899:
        return "cloud"
    default:
        return nil
    }
}
