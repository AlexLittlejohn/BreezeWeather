//
//  MakeRequest.swift
//  Breeze
//
//  Created by Alex Littlejohn on 26/04/2020.
//  Copyright © 2020 zero. All rights reserved.
//

import Combine
import Networking

let urlBase = "https://api.openweathermap.org/data/2.5/"

/// Add your open weather api key here
let appid = <#T##APIKey#>

func make<T>(request: T) -> AnyPublisher<T.Response, Error> where T: RequestType {
    return make(base: urlBase, key: appid, request: request)
}
