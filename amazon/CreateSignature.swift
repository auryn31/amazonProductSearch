//
//  CreateSignature.swift
//  amazon
//
//  Created by Mac on 22.11.15.
//  Copyright © 2015 target. All rights reserved.
//  nicht mein Algorithmus zur berechnung, sondern von http://blog.davidtruxall.com/2015/08/04/hmac-algorithm-in-swift/

import Foundation
import CommonCrypto

extension String {
    func digestHMac256(key: String) -> String! {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        let digestLen: Int = Int(CC_SHA256_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        let keyStr = key.cStringUsingEncoding(NSUTF8StringEncoding)
        let keyLen = key.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        let algorithm = CCHmacAlgorithm(kCCHmacAlgSHA256)
        CCHmac(algorithm, keyStr!, keyLen, str!, strLen, result)
        let data = NSData(bytesNoCopy: result, length: digestLen)
        let hash = data.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        return hash
    }
}