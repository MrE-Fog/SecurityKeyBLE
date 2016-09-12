//
//  APDUCommandHeader.swift
//  SecurityKeyBLE
//
//  Created by Benjamin P Toews on 9/11/16.
//  Copyright © 2016 GitHub. All rights reserved.
//

import Foundation

struct APDUHeader {
    enum CommandClass: UInt8 {
        case Reserved = 0x00
    }
    
    enum CommandCode: UInt8 {
        case Register          = 0x01
        case Authenticate      = 0x02
        case Version           = 0x03
        case CheckRegister     = 0x04
        case AuthenticateBatch = 0x05
    }
    
    let cla: CommandClass
    let ins: CommandCode
    let p1:  UInt8
    let p2:  UInt8
    let dataLength: Int
    
    init(cmdData: APDUCommandDataProtocol) throws {
        cla = cmdData.dynamicType.cmdClass
        ins = cmdData.dynamicType.cmdCode
        p1 = 0x00
        p2 = 0x00
        dataLength = cmdData.raw.length
        if dataLength > 0xFFFF { throw APDUError.BadSize }
    }
    
    init(raw: NSData) throws {
        let reader = DataReader(data: raw)
        
        do {
            let claByte:UInt8 = try reader.read()
            guard let tmpCla = CommandClass(rawValue: claByte) else { throw APDUError.BadClass }
            cla = tmpCla
            
            let insByte:UInt8 = try reader.read()
            guard let tmpIns = CommandCode(rawValue: insByte) else { throw APDUError.BadCode }
            ins = tmpIns
            
            p1 = try reader.read()
            p2 = try reader.read()
            
            let lc0:UInt8 = try reader.read()
            if lc0 > 0x00 {
                dataLength = Int(lc0)
            } else {
                let lc:UInt16 = try reader.read()
                dataLength = Int(lc)
            }
        } catch DataReader.Error.End {
            throw APDUError.BadSize
        }
    }
    
    var raw: NSData {
        let writer = DataWriter()
        
        writer.write(cla.rawValue)
        writer.write(ins.rawValue)
        writer.write(p1)
        writer.write(p2)
        
        if dataLength <= 0xFF {
            writer.write(UInt8(dataLength))
        } else {
            writer.write(UInt8(0x00))
            writer.write(UInt16(dataLength))
        }
        
        return writer.buffer
    }
}