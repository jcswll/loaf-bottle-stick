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

        guard let data = PurchaseData(coder: decoder) else {
            XCTFail("Could not construct PurchaseData from decoder.")
            return
        }

        // All expected keys, and *only* expected keys, decoded
        XCTAssert(decoder.fullyDecoded)

        // All data correct
        XCTAssertEqual(Merch(data: decoder.merch), data.merch)
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

        data.encodeWithCoder(encoder)

        // All expected keys, and *only* expected keys, encoded
        XCTAssert(encoder.fullyEncoded)

        // All data present and correct
        XCTAssertNotNil(encoder.merch)
        XCTAssertEqual(Merch(data: encoder.merch!), self.merch)
        XCTAssertNotNil(encoder.note)
        XCTAssertEqual(encoder.note!, note)
        XCTAssertNotNil(encoder.quantity)
        XCTAssertEqual(UInt(encoder.quantity!), quantity)
        XCTAssertNotNil(encoder.isCheckedOff)
        XCTAssertEqual(encoder.isCheckedOff!, isCheckedOff)
    }
}

class MockPurchaseDecoder : NSCoder
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
    var quantity: Int { return self.info["quantity"] as! Int }
    var isCheckedOff: Bool { return self.info["checkedOff"] as! Bool }

    override func decodeObjectForKey(key: String) -> AnyObject?
    {
        self.decodedKeys.append(key)
        return self.info[key]
    }

    override func decodeIntegerForKey(key: String) -> Int
    {
        self.decodedKeys.append(key)
        return (self.info[key] as? Int) ?? 0
    }
    
    override func decodeBoolForKey(key: String) -> Bool
    {
        self.decodedKeys.append(key)
        return (self.info[key] as? Bool) ?? false
    }
}

class MockPurchaseEncoder : NSCoder
{
    var fullyEncoded: Bool { 
        return self.encodedKeys.sort() == self.info.keys.sort() 
    }
    var encodedKeys: [String] = []
    var info: [String : AnyObject] = [:]

    var merch: MerchData? { return self.info["merch"] as? MerchData }
    var note: String? { return self.info["note"] as? String }
    var quantity: Int? { return self.info["quantity"] as? Int }
    var isCheckedOff: Bool? { return self.info["checkedOff"] as? Bool }

    override func encodeObject(object: AnyObject?, forKey key: String)
    {
        self.encodedKeys.append(key)
        self.info[key] = object
    }

    override func encodeInteger(integer: Int, forKey key: String)
    {
        self.encodedKeys.append(key)
        self.info[key] = integer
    }
    
    override func encodeBool(value: Bool, forKey key: String)
    {
        self.encodedKeys.append(key)
        self.info[key] = value
    }
}