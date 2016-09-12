//
//  DataWriterTests.swift
//  SecurityKeyBLE
//
//  Created by Benjamin P Toews on 9/12/16.
//  Copyright © 2016 GitHub. All rights reserved.
//

import XCTest

class DataWriterTests: XCTestCase {
    func testWrite() throws {
        let writer = DataWriter()
        writer.write(UInt8(0x00))
        writer.write(UInt8(0xFF), endian: .Little)
        writer.write(UInt16(0x0102))
        writer.write(UInt16(0x0102), endian: .Little)
        writer.writeData("AB".dataUsingEncoding(NSUTF8StringEncoding)!)

        XCTAssertEqual(NSData(int: UInt64(0x00FF010202014142)), writer.buffer)
    }
    
    func testCappedWrite() throws {
        let writer = CappedDataWriter(max: 2)
        
        try writer.write(UInt8(0x01))
        
        do {
            try writer.writeData("AB".dataUsingEncoding(NSUTF8StringEncoding)!)
        } catch CappedDataWriter.Error.MaxExceeded {
            // pass
        }
        
        do {
            try writer.write(UInt16(0x0102))
        } catch CappedDataWriter.Error.MaxExceeded {
            // pass
        }
        
        try writer.write(UInt8(0x02))
        
        XCTAssertEqual(NSData(int: UInt16(0x0102)), writer.buffer)
    }
}
