import XCTest
@testable import LoafBottleStickKit

class PurchaseDataTests : XCTestCase
{
    let merch: Merch = Merch.dummy
    
    func testHoldsData()
    {
        let note = "Get the organic stuff"
        let quantity: UInt = 3
        let isCheckedOff = true
        
        let data = PurchaseData(merch: self.merch,
                                 note: note,
                             quantity: quantity,
                           checkedOff: isCheckedOff)
        
        XCTAssertEqual(merch, data.merch)
        XCTAssertEqual(note, data.note)
        XCTAssertEqual(quantity, data.quantity)
        XCTAssertEqual(isCheckedOff, data.isCheckedOff)
    }
    
    func testCanConstructPurchase()
    {
        let note = "Get the organic stuff"
        let quantity: UInt = 3
        let isCheckedOff = true
        
        let data = PurchaseData(merch: self.merch,
                                 note: note,
                             quantity: quantity,
                           checkedOff: isCheckedOff)
        let purchase = data.item
        
        XCTAssertEqual(self.merch.name, purchase.name)
        XCTAssertEqual(self.merch.unit, purchase.unit)
        XCTAssertEqual(note, purchase.note)
        XCTAssertEqual(quantity, purchase.quantity)
        XCTAssertEqual(isCheckedOff, purchase.isCheckedOff)
    }
    
    func testCanDecomposePurchase()
    {
        let note = "Get the organic stuff"
        let quantity: UInt = 3
        let isCheckedOff = true

        let purchase = Purchase(merch: self.merch,
                                 note: note,
                             quantity: quantity,
                           checkedOff: isCheckedOff)
        let data = PurchaseData(item: purchase)

        XCTAssertEqual(self.merch, data.merch)
        XCTAssertEqual(note, data.note)
        XCTAssertEqual(quantity, data.quantity)
        XCTAssertEqual(isCheckedOff, data.isCheckedOff)
    }
    
    func testDecodesFullyAndCorrectly()
    {
        let decoder = MockPurchaseDecoder()

        guard let data = PurchaseData(decoder: decoder) else {
            XCTFail("Could not construct PurchaseData from decoder.")
            return
        }

        // All expected keys, and *only* expected keys, decoded
        XCTAssert(decoder.fullyDecoded, 
                  "Actual and expected decoding keys do not match.\n" + 
                  "Expected \(decoder.decodedKeys)\n" +
                  "Have \(Array(decoder.info.keys))")

        // All data correct
        XCTAssertEqual(decoder.merch.item, data.merch)
        XCTAssertEqual(decoder.note, data.note)
        XCTAssertEqual(UInt(decoder.quantity), data.quantity)
        XCTAssertEqual(decoder.isCheckedOff, data.isCheckedOff)
    }
    
    func testEncodesFullyAndCorrectly()
    {
        let encoder = MockPurchaseEncoder()
        let note = "Get the organic stuff"
        let quantity: UInt = 3
        let isCheckedOff = true

        let data = PurchaseData(merch: self.merch,
                                 note: note,
                             quantity: quantity,
                           checkedOff: isCheckedOff)

        data.encode(withEncoder: encoder)

        // All expected keys, and *only* expected keys, encoded
        XCTAssert(encoder.fullyEncoded,
                  "Actual and expected encoding keys do not match.\n" +
                  "Expected \(encoder.encodedKeys)\n" +
                  "Have \(Array(encoder.info.keys))")

        // All data present and correct
        stopOnFailure { XCTAssertNotNil(encoder.merch) }
        XCTAssertEqual(encoder.merch!.item, self.merch)
        stopOnFailure { XCTAssertNotNil(encoder.note) }
        XCTAssertEqual(encoder.note!, note)
        stopOnFailure { XCTAssertNotNil(encoder.quantity) }
        XCTAssertEqual(UInt(encoder.quantity!), quantity)
        stopOnFailure { XCTAssertNotNil(encoder.isCheckedOff) }
        XCTAssertEqual(encoder.isCheckedOff!, isCheckedOff)
    }
}

final class MockPurchaseDecoder : Decoder
{
    var fullyDecoded: Bool { 
        return self.decodedKeys.sort() == self.info.keys.sort() 
    }
    // Collect all keys decoded (including duplicates).
    var decodedKeys: [String] = []
    var info: [String : AnyObject] = ["merch" : MerchData(item: Merch.dummy),
                                      "note" : "Get the organic stuff", 
                                      "quantity" : 3, 
                                      "checkedOff" : true]

    var merch: MerchData { return self.info["merch"] as! MerchData }
    var note: String { return self.info["note"] as! String }
    var quantity: UInt { return self.info["quantity"] as! UInt }
    var isCheckedOff: Bool { return self.info["checkedOff"] as! Bool }
    
    init() {}
    
    init(forReadingWithData: NSData) {}

    func decodeEncodable(forKey key: String) -> Decodable?
    {
        self.decodedKeys.append(key)
        return self.info[key] as? Decodable
    }

    func decodeDate(forKey key: String) -> NSDate?
    {
        self.decodedKeys.append(key)
        return self.info[key] as? NSDate
    }

    func decodeString(forKey key: String) -> String?
    {
        self.decodedKeys.append(key)
        return self.info[key] as? String
    }

    func decodeInt(forKey key: String) -> Int?
    {
        self.decodedKeys.append(key)
        return self.info[key] as? Int
    }

    func decodeUnsignedInt(forKey key: String) -> UInt?
    {
        self.decodedKeys.append(key)
        return self.info[key] as? UInt
    }

    func decodeBool(forKey key: String) -> Bool?
    {
        self.decodedKeys.append(key)
        return self.info[key] as? Bool
    }
}

final class MockPurchaseEncoder : Encoder
{
    var fullyEncoded: Bool { 
        return self.encodedKeys.sort() == self.info.keys.sort() 
    }
    var encodedKeys: [String] = ["merch", "note", "quantity", "checkedOff"]
    var info: [String : AnyObject] = [:]

    var merch: MerchData? { return self.info["merch"] as? MerchData }
    var note: String? { return self.info["note"] as? String }
    var quantity: Int? { return self.info["quantity"] as? Int }
    var isCheckedOff: Bool? { return self.info["checkedOff"] as? Bool }

    init() {}
    
    init(forWritingWithMutableData: NSMutableData) {}
   
    func encode(codable codable: Encodable, forKey key: String)
    {
        guard let object = codable as? AnyObject else {
            return
        }
        self.info[key] = object
    }
    
    func encode(unsignedInt uint: UInt, forKey key: String)  
    {
        self.info[key] = uint  
    }
    
    func encode(string string: String, forKey key: String)
    {
        self.info[key] = string
    }
    
    func encode(date date: NSDate, forKey key: String)
    {
        self.info[key] = date
    }
    
    func encode(bool bool: Bool, forKey key: String)
    {
        self.info[key] = bool
    }
}