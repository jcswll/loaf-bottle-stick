import XCTest
@testable import LoafBottleStickKit

class MerchDataTests : XCTestCase
{
    func testHoldsData()
    {
        let name = "Broccoli"
        let unit = Unit.Head
        let numUses: UInt = 17
        let lastUsed = NSDate.distantFuture()
        
        let data = MerchData(name: name, 
                             unit: unit,
                          numUses: numUses, 
                         lastUsed: lastUsed)
        
         XCTAssertEqual(name, data.name)
         XCTAssertEqual(unit, data.unit)
         XCTAssertEqual(numUses, data.numUses)
         XCTAssertEqual(lastUsed, data.lastUsed)
    }
    
    func testCanConstructMerch()
    {
        let name = "Broccoli"
        let unit = Unit.Head
        let numUses: UInt = 17
        let lastUsed = NSDate.distantFuture()
        
        let data = MerchData(name: name, 
                             unit: unit, 
                          numUses: numUses, 
                         lastUsed: lastUsed)
        let merch = data.item
        
        XCTAssertEqual(name, merch.name)
        XCTAssertEqual(unit, merch.unit)
        XCTAssertEqual(numUses, merch.numUses)
        XCTAssertEqual(lastUsed, merch.lastUsed)
    }
    
    func testCanDecomposeMerch()
    {
        let name = "Broccoli"
        let unit = Unit.Head
        let numUses: UInt = 17
        let lastUsed = NSDate.distantFuture()
        
        let merch = Merch(name: name, unit: unit, 
                          numUses: numUses, lastUsed: lastUsed)
        let data = MerchData(item: merch)
        
        XCTAssertEqual(name, data.name)
        XCTAssertEqual(unit, data.unit)
        XCTAssertEqual(numUses, data.numUses)
        XCTAssertEqual(lastUsed, data.lastUsed)
    }
    
    func testDecodesFullyAndCorrectly()
    {
        let decoder = MockMerchDecoder()

        guard let data = MerchData(decoder: decoder) else {
            XCTFail("Could not construct Merch from decoder.")
            return
        }

        // All expected keys, and *only* expected keys, decoded
        XCTAssert(decoder.fullyDecoded,
                  "Actual and expected decoding keys do not match.\n" +
                  "Expected \(decoder.decodedKeys)\n" +
                  "Have \(Array(decoder.info.keys))")

        // All data correct
        XCTAssertEqual(decoder.name, data.name)
        XCTAssertEqual(Unit(rawValue: decoder.unit)!, data.unit)
        XCTAssertEqual(UInt(decoder.numUses), data.numUses)
        XCTAssertEqual(decoder.lastUsed, data.lastUsed)
    }
    
    func testEncodesFullyAndCorrectly()
    {
        let encoder = MockMerchEncoder()
        let name = "Broccoli"
        let unit = Unit.Head
        let numUses: UInt = 17
        let lastUsed = NSDate.distantFuture()
        
        let data = MerchData(name: name,
                             unit: unit,
                          numUses: numUses,
                         lastUsed: lastUsed)
                         
        data.encode(withEncoder: encoder)
        
        // All expected keys, and *only* expected keys, encoded
        XCTAssert(encoder.fullyEncoded,
                  "Actual and expected encoding keys do not match.\n" +
                  "Expected \(encoder.encodedKeys)\n" +
                  "Have \(Array(encoder.info.keys))")
        
        // All data present and correct
        stopOnFailure { XCTAssertNotNil(encoder.name) }
        XCTAssertEqual(encoder.name!, name)
        stopOnFailure { XCTAssertNotNil(encoder.unit) }
        guard let encodedUnit = Unit(rawValue: encoder.unit!) else {
            XCTFail("Merch's unit failed to encode")
            return
        }
        XCTAssertEqual(encodedUnit, unit)
        stopOnFailure { XCTAssertNotNil(encoder.numUses) }
        XCTAssertEqual(UInt(encoder.numUses!), numUses)
        stopOnFailure { XCTAssertNotNil(encoder.lastUsed) }
        XCTAssertEqual(encoder.lastUsed!, lastUsed)
    }
}

final class MockMerchDecoder : Decoder 
{
    var fullyDecoded: Bool { 
        return self.decodedKeys.sort() == self.info.keys.sort()
    }
    var decodedKeys: [String] = []
    var info: [String : AnyObject] = ["name" : "Broccoli",
                                      "unit" : "Head",
                                      "numUses" : 17,
                                      "lastUsed" : NSDate.distantFuture()]
    
    var name: String { return self.info["name"] as! String }
    var unit: String { return self.info["unit"] as! String }
    var numUses: Int { return self.info["numUses"] as! Int }
    var lastUsed: NSDate { return self.info["lastUsed"] as! NSDate }
    
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

final class MockMerchEncoder : Encoder
{
    var fullyEncoded: Bool { 
        return self.encodedKeys.sort() == self.info.keys.sort()
    }
    var encodedKeys: [String] = ["name", "unit", "numUses", "lastUsed"]
    var info: [String : AnyObject] = [:]
    
    var name: String? { return self.info["name"] as? String }
    var unit: String? { return self.info["unit"] as? String }
    var numUses: Int? { return self.info["numUses"] as? Int }
    var lastUsed: NSDate? { return self.info["lastUsed"] as? NSDate }
    
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
}
