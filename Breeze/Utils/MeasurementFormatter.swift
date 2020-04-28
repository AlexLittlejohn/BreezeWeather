//
//  TemperatureFormatter.swift
//  Breeze
//
//  Created by Alex Littlejohn on 26/04/2020.
//  Copyright © 2020 zero. All rights reserved.
//

import Foundation

let measurementFormatter = MeasurementFormatter().then {
    $0.unitStyle = .short
    $0.unitOptions = .temperatureWithoutUnit
    $0.numberFormatter.maximumFractionDigits = 0
    $0.numberFormatter.roundingMode = .halfUp
}

func formatted(kelvin: Double, in unit: UnitTemperature) -> String {
    var temperature = Measurement(value: kelvin, unit: UnitTemperature.kelvin).converted(to: unit)
    temperature.value = round(temperature.value)
    return measurementFormatter.string(from: temperature)
}

func formatted(meters: Double, in unit: UnitSpeed) -> String {
    var temperature = Measurement(value: meters, unit: UnitSpeed.metersPerSecond).converted(to: unit)
    temperature.value = round(temperature.value)
    return measurementFormatter.string(from: temperature)
}

func formatted(degrees value: Double) -> String {
    measurementFormatter.string(from: Measurement(value: value, unit: UnitAngle.degrees))
}

func formatted(pressure value: Double) -> String {
    measurementFormatter.string(from: Measurement(value: value, unit: UnitPressure.hectopascals))
}

let numberFormatter = NumberFormatter().then {
    $0.numberStyle = .percent
}

func formatted(percentage value: Double) -> String {
    numberFormatter.string(from: NSNumber(value: value)) ?? "\(value) %"
}
