//
//  UserDefault.swift
//  Breeze
//
//  Created by Alex Littlejohn on 26/04/2020.
//  Copyright © 2020 zero. All rights reserved.
//

import Foundation

@propertyWrapper
class UserDefault<Value> {
    
    let key: String
    let defaults: UserDefaults
    let defaultValue: Value

    var wrappedValue: Value {
        get { defaults.object(forKey: key) as? Value ?? defaultValue }
        set { defaults.set(newValue, forKey: key) }
    }
    
    convenience init<T: RawRepresentable>(wrappedValue: Value, _ key: T, defaults: UserDefaults = UserDefaults.standard) where T.RawValue == String {
        self.init(wrappedValue: wrappedValue, key.rawValue, defaults: defaults)
    }

    init(wrappedValue: Value, _ key: String, defaults: UserDefaults = UserDefaults.standard) {
        self.key = key
        self.defaults = defaults
        self.defaultValue = wrappedValue
    }
}

@propertyWrapper
class CodableUserDefault<Value: Codable> {
    
    let key: String
    let defaults: UserDefaults
    let defaultValue: Value

    let encoder = PropertyListEncoder()
    let decoder = PropertyListDecoder()

    var wrappedValue: Value {
        get {
            guard let data = defaults.data(forKey: key), let response = try? decoder.decode(Value.self, from: data) else { return defaultValue }
            return response
        }
        set {
            guard let data = try? encoder.encode(newValue) else {
                defaults.set(nil, forKey: key)
                return
            }
            defaults.set(data, forKey: key)
        }
    }
    
    convenience init<T: RawRepresentable>(wrappedValue: Value, _ key: T, defaults: UserDefaults = UserDefaults.standard) where T.RawValue == String {
        self.init(wrappedValue: wrappedValue, key.rawValue, defaults: defaults)
    }
    
    init(wrappedValue: Value, _ key: String, defaults: UserDefaults = UserDefaults.standard) {
        self.key = key
        self.defaults = defaults
        self.defaultValue = wrappedValue
    }
}
