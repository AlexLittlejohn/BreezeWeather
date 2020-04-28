//
//  TimeFormatter.swift
//  Breeze
//
//  Created by Alex Littlejohn on 27/04/2020.
//  Copyright © 2020 zero. All rights reserved.
//

import Foundation

let mediumTimeFormatter = DateFormatter().then {
    $0.timeStyle = .short
    $0.dateStyle = .none
}

let shortTimeFormatter = DateFormatter().then {
    $0.setLocalizedDateFormatFromTemplate("h a")
}

let dayFormatter = DateFormatter().then {
    $0.dateFormat = "EEEE"
}

func formatted(timezone offset: Int) -> String {
    let date = Date()
    mediumTimeFormatter.timeZone = TimeZone(secondsFromGMT: offset)
    return mediumTimeFormatter.string(from: date)
}

func formatted(timezone name: String) -> String {
    let date = Date()
    mediumTimeFormatter.timeZone = TimeZone(identifier: name)
    return mediumTimeFormatter.string(from: date)
}

func mediumHourlyTime(timezone name: String, time: Double) -> String {
    let date = Date(timeIntervalSince1970: time)
    mediumTimeFormatter.timeZone = TimeZone(identifier: name)
    return mediumTimeFormatter.string(from: date)
}

func hourlyTime(timezone name: String, time: Double) -> String {
    let date = Date(timeIntervalSince1970: time)
    shortTimeFormatter.timeZone = TimeZone(identifier: name)
    return shortTimeFormatter.string(from: date)
}

func dayTime(timezone name: String, time: Double) -> String {
    let date = Date(timeIntervalSince1970: time)
    dayFormatter.timeZone = TimeZone(identifier: name)
    return dayFormatter.string(from: date)
}

//func formatted(timezone name: String, time: Double) -> String {
//    let date = Date(timeIntervalSince1970: time)
//    timeFormatter.timeZone = TimeZone(identifier: name)
//    return timeFormatter.string(from: date)
//}
//
//func formatted(timezone name: String) -> String {
//    let date = Date()
//    timeFormatter.timeZone = TimeZone(identifier: name)
//    return timeFormatter.string(from: date)
//}
//
//func formatted(day time: Double) -> String {
//    let date = Date(timeIntervalSince1970: time)
//    return timeFormatter.string(from: date)
//}
