//
//  LocationStorage.swift
//  Breeze
//
//  Created by Alex Littlejohn on 27/04/2020.
//  Copyright © 2020 zero. All rights reserved.
//

import Foundation

struct SavedLocation: Hashable, Codable {
    let id: String
    let name: String
    let coord: Coordinates
    
    static let empty = SavedLocation(id: "", name: "", coord: Coordinates(lat: 0, lon: 0))
}

class LocationStorage {
    
    static let shared = LocationStorage()
    
    private(set) var savedLocations: [SavedLocation]
    private let defaults = UserDefaults.standard
    private let storageKey = "SavedLocations"
    
    init() {
        guard let data = defaults.data(forKey: storageKey),
            let decoded = try? PropertyListDecoder().decode([SavedLocation].self, from: data) else {
            savedLocations = []
            return
        }
        
        savedLocations = decoded
    }
    
    func add(location: SavedLocation) {
        guard !savedLocations.contains(location) else { return }
        savedLocations.append(location)
        
        sync()
    }
    
    func remove(location: SavedLocation) {
        guard let index = savedLocations.firstIndex(of: location) else { return }
        savedLocations.remove(at: index)
        
        sync()
    }
    
    func sync() {
        guard let data = try? PropertyListEncoder().encode(savedLocations) else { return }
        defaults.set(data, forKey: storageKey)
        
    }
    
    func getAllLocationsFromCache() {
        guard let data = defaults.data(forKey: storageKey),
            let decoded = try? PropertyListDecoder().decode([SavedLocation].self, from: data) else {
                self.savedLocations = []
            return
        }
        
        self.savedLocations = decoded
    }
    
    deinit {
        sync()
    }
}
