//
//  Encodable+Extension.swift
//  AxonCardSuite
//
//  Created by Abhinav Mathur on 17/08/22.
//

import Foundation

public extension Encodable {
    var asDictionary: [AnyHashable: Any]? {
        guard let encodedData = try? JSONEncoder().encode(self),
              let json = try? JSONSerialization.jsonObject(with: encodedData),
              let dictionary = json as? [AnyHashable: Any] else {
            return nil
        }
        return dictionary
    }
}
