//
//  NetworkingTests.swift
//  NetworkingTests
//
//  Created by Alex Littlejohn on 26/04/2020.
//  Copyright © 2020 zero. All rights reserved.
//

import XCTest
@testable import Networking

struct TestResponse: Codable {
    let value: String
}

struct TestRequest: RequestType {
    let type: String

    var path: String {
        return "collection"
    }
    
    typealias Response = TestResponse
}

class RequestTypeTests: XCTestCase {
    
    var mockRequest: TestRequest?
    var apiKey: String?
    var apiBaseURL: String?

    override func setUp() {
        mockRequest = TestRequest(type: "painting")
        apiKey = "apiKey"
        apiBaseURL = "https://www.google.com/"
    }

    override func tearDown() {
        mockRequest = nil
        apiKey = nil
        apiBaseURL = nil
    }
    
    func testMakeParameters() {
        let p = ["type": "painting"]
        XCTAssertEqual(p, mockRequest!.makeParameters())
    }
    
    func testMakeQuery() {
        let items = [
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "type", value: "painting")
        ]
        XCTAssertEqual(items, mockRequest!.makeQuery(key: apiKey!))
    }

    func testMakeURL() {
        let url = "\(apiBaseURL!)collection?appid=\(apiKey!)&type=painting"
        XCTAssertEqual(url, try! mockRequest!.makeURL(base: apiBaseURL!, key: apiKey!).absoluteString)
    }
}
