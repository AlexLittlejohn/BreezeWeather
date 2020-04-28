//
//  CurrentLocationHelper.swift
//  Breeze
//
//  Created by Alex Littlejohn on 27/04/2020.
//  Copyright © 2020 zero. All rights reserved.
//

import Combine
import Foundation
import CoreLocation
import UIKit

class CurrentLocationHelper: NSObject, CLLocationManagerDelegate {
    
    enum LocationError: Error {
        case restricted
    }
    
    private let manager = CLLocationManager()
    private let subject = PassthroughSubject<CLLocation, Error>()
    
    lazy var publisher = subject.eraseToAnyPublisher()

    override init() {
        super.init()
        manager.delegate = self
    }
    
    func canFetchLocation() -> Bool {
        let status = CLLocationManager.authorizationStatus()
        return status == .authorizedWhenInUse || status == .authorizedAlways
    }
    
    func requestLocationServices() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            requestLocation()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            subject.send(completion: Subscribers.Completion.failure(LocationError.restricted))
        case .denied:
            requestLocationServicesInSettings()
        @unknown default:
            return
        }
    }
    
    private func requestLocationServicesInSettings() {
        if !CLLocationManager.locationServicesEnabled(), let systemSettings = URL(string: "App-Prefs:root=Privacy&path=LOCATION") {
            UIApplication.shared.open(systemSettings)
        } else if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSettings)
        }
    }

    func requestLocation() {
        guard canFetchLocation() else { return }
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        subject.send(location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        subject.send(completion: Subscribers.Completion.failure(error))
    }
}

