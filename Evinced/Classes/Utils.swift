//
//  Utils.swift
//  EvincedSDKiOS
//
//  Copyright © Evinced, Inc. All rights reserved.
//

import Foundation

struct JSONStringEncoder {
    /**
     Encodes a dictionary into a JSON string.
     - parameter dictionary: Dictionary to use to encode JSON string.
     - returns: A JSON string. `nil`, when encoding failed.
     */
    static func encode(_ dictionary: [String: Any]) -> String? {
        guard JSONSerialization.isValidJSONObject(dictionary) else {
            assertionFailure("Invalid json object received.")
            return nil
        }

        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        let jsonData: Data

        dictionary.forEach { (arg) in
            jsonObject.setValue(arg.value, forKey: arg.key)
        }

        do {
            jsonData = try JSONSerialization.data(withJSONObject: jsonObject)
        } catch {
            assertionFailure("JSON data creation failed with error: \(error).")
            return nil
        }

        guard let jsonString = String.init(data: jsonData, encoding: String.Encoding.utf8) else {
            assertionFailure("JSON string creation failed.")
            return nil
        }

        return jsonString
    }
    
    static func decode(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                Logger.log(error.localizedDescription)
            }
        }
        return nil
    }
}

func validSocketUrl(_ urlString: String) -> URL? {
    guard let url = URL(string: urlString),
          url.scheme == "wss",
          (url.port ?? 0) <= UInt16.max else { return nil }
    
    return url
}

func getVersion() -> String? {
    // using some file in the sdk to get the bundle
    let bundle = Bundle(for: type(of: Socket.shared))
    
    let versionNumber = bundle.infoDictionary?["CFBundleShortVersionString"] as! String
    let buildNumber = bundle.infoDictionary?["CFBundleVersion"] as! String
    
    return "\(versionNumber) (Build \(buildNumber))"
}
