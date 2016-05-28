//
//  DestinationTests.swift
//  smart-alarm
//
//  Created by Shiv Kalola on 12/8/16.
//  Copyright © 2016 Nobel Apps. All rights reserved.
//

import XCTest
@testable import smart_alarm

class DestinationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDefaultConstructor() {
        let destination = Destination()
        XCTAssert(destination.name == "")
        XCTAssert(destination.lat == 0.0)
        XCTAssert(destination.long == 0.0)
    }
    
    func testParamConstructor() {
        let dest1 = Destination(name: "Test", lat: 2.0, long: 3.0)
        XCTAssert(dest1.name == "Test")
        XCTAssert(dest1.lat == 2.0)
        XCTAssert(dest1.long == 3.0)
    }
    
    func testSerialization() {
        let dest1 = Destination(name: "Test", lat: 2.0, long: 3.0)
        let destAsDict = dest1.toDictionary()
        let dest2 = Destination()
        dest2.fromDictionary(destAsDict)
        XCTAssert(dest2.name == "Test")
        XCTAssert(dest2.lat == 2.0)
        XCTAssert(dest2.long == 3.0)
    }
    
}
