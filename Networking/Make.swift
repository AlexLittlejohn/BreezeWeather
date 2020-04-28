//
//  Make.swift
//  Networking
//
//  Created by Alex Littlejohn on 26/04/2020.
//  Copyright © 2020 zero. All rights reserved.
//

import Foundation
import Combine

/// This method will generate a url from a RequestType.
///
/// - Parameters:
///   - base: The base url to perform queries against
///   - key: The api key for making requests
///   - request: A request object conforming to `RequestType`
/// - Returns: A publisher
public func make<T>(base: String, key: String, request: T) -> AnyPublisher<T.Response, Error> where T: RequestType {
    
    return CurrentValueSubject<(String, String), Error>((base, key))
        .tryMap { try request.makeURL(base: $0.0, key: $0.1) }
        .flatMap { URLSession.shared.dataTaskPublisher(for: $0).mapError { $0 as Error } }
        .map { $0.data }
        .decode(type: T.Response.self, decoder: JSONDecoder())
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
}
