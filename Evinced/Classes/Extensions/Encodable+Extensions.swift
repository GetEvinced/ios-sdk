//
//  Encodable+Extensions.swift
//  EvincedSDKiOS
//
//  Copyright © Evinced, Inc. All rights reserved.
//

import Foundation

private let encoder: JSONEncoder = {
    let encoder = JSONEncoder()
    encoder.nonConformingFloatEncodingStrategy = .convertToString(positiveInfinity: "+infinity",
                                                                  negativeInfinity: "-infinity",
                                                                  nan: "nan")
    return encoder
}()

extension Encodable {
    // object to string func
    func stringify() -> String? {
        guard let data = try? encoder.encode(self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    func data() -> Data? {
        return try? encoder.encode(self)
    }
}
