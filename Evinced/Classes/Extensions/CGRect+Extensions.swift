//
//  CGRect+Extensions.swift
//  EvincedSDKiOS
//
//  Copyright © Evinced, Inc. All rights reserved.
//

import Foundation

struct NamedCGRect: Encodable {
    let x: CGFloat
    let y: CGFloat
    let width: CGFloat
    let height: CGFloat
}

extension CGRect {
    var namedCgRect: NamedCGRect {
        NamedCGRect(x: origin.x,
                    y: origin.y,
                    width: size.width,
                    height: size.height)
    }
}
