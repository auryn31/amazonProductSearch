

let associate_tag_default = "weio-20"
let aws_key_default = "your amazon key"
let aws_secret_default = "your amazon secret"

let asin = "B00DVDMRX6" // an amazon id to search for

let serializer = AmazonSerializer(key: aws_key_default, secret: aws_secret_default)

let amazonParams = [
    "Service" : "AWSECommerceService",
    "Operation" : "ItemLookup",
    "ResponseGroup" : "Images,ItemAttributes",
    "IdType" : "ASIN",
    "ItemId" : asin,
    "AssociateTag" : associate_tag_default,
    "Condition" : "All"
]
        
amazonRequest(parameters: amazonParams, serializer: serializer).responseXML { (req, res, data, error) -> Void in
    println("Got results! \(data)")
}

