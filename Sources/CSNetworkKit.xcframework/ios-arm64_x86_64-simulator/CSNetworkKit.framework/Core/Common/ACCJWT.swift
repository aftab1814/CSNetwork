//
//  ACCJWT.swift
//  AxonCardSuite
//
//  Created by Aniket Bidwai on 23/08/22.
//

import Foundation
#if canImport(CryptoKit)
import CryptoKit
#endif

@available(iOS 13.0, *)
public class ACCJWT {
    
    var payload: [AnyHashable: Any]
    
    public init(with payload: [AnyHashable: Any]) {
        self.payload = payload
    }
    
    private struct Header: Encodable {
        let alg = "ES256"
        let typ = "JWT"
    }
    
    public func encodedToken(with privateKey: SymmetricKey) -> String? {
        guard let headerJSONData = try? JSONEncoder().encode(Header()),
              let payloadJSONData = self.payload.jsonData() else {
            return nil
        }
        
        let headerBase64String = headerJSONData.urlSafeBase64EncodedString()
        let payloadBase64String = payloadJSONData.urlSafeBase64EncodedString()

        let toSign = Data((headerBase64String + "." + payloadBase64String).utf8)

        let signature = HMAC<SHA256>.authenticationCode(for: toSign, using: privateKey)
        let signatureBase64String = Data(signature).urlSafeBase64EncodedString()

        return [headerBase64String, payloadBase64String, signatureBase64String].joined(separator: ".")
    }
}
