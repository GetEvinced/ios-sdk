//
//  Encodable+Extensions.swift
//  EvincedSDKiOS
//
//  Copyright © Evinced, Inc. All rights reserved.
//

import Foundation

extension Encodable {
    // object to string func
    func stringify() -> String? {
        let encoder = JSONEncoder()

        var data: Data?
        
        do {
           data = try encoder.encode(self)
        } catch {}

        let dataAsString = String(data: data!, encoding: .utf8)
    
        return dataAsString
    }
    
    func data() -> Data? {
        let encoder = JSONEncoder()

        var data: Data?
        
        do {
           data = try encoder.encode(self)
        } catch {}
        
        return data
    }
}
