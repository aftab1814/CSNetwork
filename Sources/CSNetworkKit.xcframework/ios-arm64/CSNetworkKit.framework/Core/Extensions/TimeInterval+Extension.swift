//
//  TimeInterval+Extension.swift
//  AxonCardSuite
//
//  Created by Abhinav Mathur on 12/09/22.
//

import Foundation

public extension TimeInterval {
    var millisecondsSince1970: Int64 {
        Int64((self * 1000.0).rounded())
    }
    
    init(milliseconds: Int64) {
        self = TimeInterval(milliseconds) / 1000
    }
}
