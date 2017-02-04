//
//  AmazonProduct.swift
//  Requires SHXMLParser for parsing Amazon's XML responses (https://github .com/simhanature/SHXMLParser)
//
//  Created by Cory Alder on 2015-01-11.
//  Copyright (c) 2015 Davander Mobile Corporation. All rights reserved.
//

import Alamofire
import Foundation

enum AmazonProductAdvertising: String {
    case StandardRegion = "webservices.amazon.com"
    case AWSAccessKey = "access"
    case TimestampKey = "Timestamp"
    case SignatureKey = "Signature"
    case VersionKey = "Version"
    case AssociateTagKey = "AssociateTag"
    case CurrentVersion = "2011-08-01"
}

let AWSDateISO8601DateFormat3 = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"


func amazonRequest(parameters: [String: AnyObject]? = nil, serializer ser: AmazonSerializer?) -> Alamofire.Request {
    
    let serializer: AmazonSerializer = {
        if let s = ser {
            return s
        } else {
            let s = AmazonSerializer(key: "KEY", secret: "SecretKey")
            s.useSSL = false
            return s
        }
    }()
    
    let URL = serializer.endpointURL()
    
    let e = Alamofire.ParameterEncoding.Custom(serializer.serializerBlock())
    
    let mutableURLRequest = NSMutableURLRequest(URL: URL)
    
    mutableURLRequest.HTTPMethod = Alamofire.Method.GET.rawValue
    
    let encoded: URLRequestConvertible  = e.encode(mutableURLRequest, parameters: parameters).0
    
    return Alamofire.request(encoded)
}

class AmazonSerializer {
    
    let accessKey: String
    let secret: String
    
    var region: String = AmazonProductAdvertising.StandardRegion.rawValue
    var formatPath: String = "/onca/xml"
    var useSSL = true
    
    init(key: String, secret sec: String) {
        self.secret = sec
        self.accessKey = key
    }
    
    func endpointURL() -> NSURL {
        let scheme = useSSL ? "https" : "http"
        let URL = NSURL(string: "https://\(region)\(formatPath)")
        return URL!
    }
    
    func serializerBlock() -> (URLRequestConvertible, [String: AnyObject]?) -> (NSMutableURLRequest, NSError?) {
        return { (req, params) -> (NSURLRequest, NSError?) in
            
            // TODO: if params == nil error out ASAP
            
            var mutableParameters = params!
            
            let timestamp = AmazonSerializer.ISO8601FormatStringFromDate(NSDate())
            
            if mutableParameters[AmazonProductAdvertising.AWSAccessKey.rawValue] == nil {
                mutableParameters[AmazonProductAdvertising.AWSAccessKey.rawValue] = self.accessKey
            }
            
            
            mutableParameters[AmazonProductAdvertising.VersionKey.rawValue] = AmazonProductAdvertising.CurrentVersion.rawValue;
            mutableParameters[AmazonProductAdvertising.TimestampKey.rawValue] = timestamp;
            
            var canonicalStringArray = [String]()
        
            // alphabetize
            let sortedKeys = Array(mutableParameters.keys).sorted {$0 < $1}
            
            for key in sortedKeys {
                canonicalStringArray.append("\(key)=\(mutableParameters[key]!)")
            }
            
            let canonicalString = join("&", canonicalStringArray)

            var encodedCanonicalString = CFURLCreateStringByAddingPercentEscapes(
                nil,
                canonicalString,
                nil,
                ":,",//"!*'();:@&=+$,/?%#[]",
                CFStringBuiltInEncodings.UTF8.rawValue
            )
            
            let method = req.URLRequest.HTTPMethod
            
            let signature = "\(method)\n\(self.region)\n\(self.formatPath)\n\(encodedCanonicalString)"
            
            let encodedSignatureData = signature.hmacSHA256(self.secret)
            var encodedSignatureString = encodedSignatureData.base64EncodedString()
            
            encodedSignatureString = CFURLCreateStringByAddingPercentEscapes(
                nil,
                encodedSignatureString,
                nil,
                "+=",//"!*'();:@&=+$,/?%#[]",
                CFStringBuiltInEncodings.UTF8.rawValue
            )
            
            let newCanonicalString = "\(encodedCanonicalString)&\(AmazonProductAdvertising.SignatureKey.rawValue)=\(encodedSignatureString)"
            
            let urlString = req.URLRequest.URL.query != nil ? "\(req.URLRequest.URL.absoluteString!)&\(newCanonicalString)" : "\(req.URLRequest.URL.absoluteString!)?\(newCanonicalString)"
            
            var request = req.URLRequest.mutableCopy() as! NSMutableURLRequest
            request.URL = NSURL(string: urlString)
            
            return (request, NSError())
        }
    }

    
    private class func ISO8601FormatStringFromDate(date: NSDate) -> NSString {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "GMT")
        dateFormatter.dateFormat = AWSDateISO8601DateFormat3//"YYYY-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return dateFormatter.stringFromDate(date)
    }


}

// HMAC and base64 helpers

public extension String {
    
    func hmacSHA256(key: String) -> NSData {
        let inputData: NSData = self.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: false)!
        let keyData: NSData = key.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: false)!
        
        let digestLen = Int(CC_SHA256_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        
        CCHmac(UInt32(kCCHmacAlgSHA256), keyData.bytes, UInt(keyData.length), inputData.bytes, UInt(inputData.length), result)
        let data = NSData(bytes: result, length: digestLen)
        return data
    }
    
}

public extension NSData {
    func base64EncodedString() -> String {
        return self.base64EncodedStringWithOptions(nil)
    }
}


// XML ResponseSerializer


extension Request {
    class func XMLResponseSerializer() -> Serializer {
        return { (request, response, data) in
            if data == nil {
                return (nil, nil)
            }
            
            var XMLSerializationError: NSError?
            
            let parser = SHXMLParser()
            let document = parser.parseData(data)
            
            return (document, XMLSerializationError)
        }
    }
    
    public func responseXML(completionHandler: (NSURLRequest, NSHTTPURLResponse?, Dictionary<String, AnyObject>?, NSError?) -> Void) -> Self {
        let ser: Serializer = Request.XMLResponseSerializer()
        //let res = response(dispatch_get_main_queue(), ser) { (request, response, XML, error) in
          //  completionHandler(request, response, XML, error)
        //}
        
        return response(queue: dispatch_get_main_queue(), serializer: Request.XMLResponseSerializer()) { (req, res, xml, error) -> Void in
            completionHandler(req, res, xml as? Dictionary<String, AnyObject>, error)
        }
    }
}

