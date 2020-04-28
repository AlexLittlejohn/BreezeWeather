//
//  RequestType.swift
//  Networking
//
//  Created by Alex Littlejohn on 26/04/2020.
//  Copyright © 2020 zero. All rights reserved.
//

import Foundation

public protocol RequestType {
    associatedtype Response: Decodable
    
    var path: String { get }
    func makeParameters() -> [String: String]
    func makeQuery(key: String) -> [URLQueryItem]
    func makeURL(base: String, key: String) throws -> URL
}

public extension RequestType {
    func makeParameters() -> [String: String] {
        let mirror = Mirror(reflecting: self)
        
        return mirror.children.reduce(into: [:], { (io, pair) in
            guard let label = pair.label else { return }
            // this is a pretty niave approach (assuiming all values will be string representable) but it will work for our request types
            io[label] = String(describing: pair.value)
        })
    }
    
    func makeQuery(key: String) -> [URLQueryItem] {
        
        let keyItem = URLQueryItem(name: "appid", value: key)
        
        return makeParameters().reduce(into: [keyItem]) { io, pair in
            io.append(URLQueryItem(name: pair.key, value: pair.value))
        }
    }
    
    func makeURL(base: String, key: String) throws -> URL {
        let fullPath = base + path
        var builder = URLComponents(string: fullPath)
        builder?.queryItems = makeQuery(key: key)
        
        guard let url = builder?.url else {
            throw URLError(.badURL)
        }
        
        return url
    }
}
