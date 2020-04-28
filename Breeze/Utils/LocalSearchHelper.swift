//
//  LocalSearchHelper.swift
//  Breeze
//
//  Created by Alex Littlejohn on 27/04/2020.
//  Copyright © 2020 zero. All rights reserved.
//

import Combine
import Foundation
import MapKit

class LocalSearchHelper: NSObject, MKLocalSearchCompleterDelegate {
    
    private let searcher = MKLocalSearchCompleter()
    private let subject = PassthroughSubject<[MKLocalSearchCompletion], Error>()
    
    lazy var publisher = subject.eraseToAnyPublisher()

    override init() {
        super.init()
        searcher.delegate = self
    }
    
    func setQuery( _ query: String) {
        searcher.queryFragment = query
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        subject.send(completer.results)
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        subject.send(completion: Subscribers.Completion.failure(error))
    }
    
    static func makeSearch(for completion: MKLocalSearchCompletion) -> MKLocalSearch {
        MKLocalSearch(request: MKLocalSearch.Request(completion: completion))
    }
    
    static func publisher(for search: MKLocalSearch) -> AnyPublisher<CLLocationCoordinate2D, Error> {
        
        return Future<CLLocationCoordinate2D, Error>{ completion in
            search.start { (response, error) in
                
                if let error = error {
                    completion(.failure(error))
                }
                
                if let item = response?.mapItems.first {
                    completion(.success(item.placemark.coordinate))
                }
            }
        }.eraseToAnyPublisher()
    }
}

