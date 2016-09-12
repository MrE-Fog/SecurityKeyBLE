//
//  CoreExtensionsTests.swift
//  SecurityKeyBLE
//
//  Created by Benjamin P Toews on 9/12/16.
//  Copyright © 2016 GitHub. All rights reserved.
//

import XCTest

class CoreExtensionsTests: XCTestCase {
    func testInitWithUInt16() throws {
        var data:NSData
        var actual:UInt16
        var expected:UInt16
        
        expected = 0x0102
        data = NSData(int: expected)
        actual = try DataReader(data: data).read()
        XCTAssertEqual(expected, actual)
        
        data = NSData(int: expected, endian: .Little)
        actual = try DataReader(data: data).read()
        expected = 0x0201
        XCTAssertEqual(expected, actual)
    }
}
