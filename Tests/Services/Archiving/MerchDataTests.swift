import XCTest
@testable import LoafBottleStickKit

class MerchDataTests : XCTestCase
{
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
        let merch = Merch(data: data)
        
        XCTAssertEqual(name, merch.name)
        XCTAssertEqual(unit, merch.unit)
        XCTAssertEqual(numUses, merch.numUses)
        XCTAssertEqual(lastUsed, merch.lastUsed)
    }
    
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
        
        guard let data = MerchData(coder: decoder) else {
            XCTFail("Could not construct Merch from decoder.")
            return
        }
        
        // All expected keys, and *only* expected keys, decoded
        XCTAssert(decoder.fullyDecoded)
        
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
                         
        data.encodeWithCoder(encoder)
        
        // All expected keys, and *only* expected keys, encoded
        XCTAssert(encoder.fullyEncoded)
        
        // All data correct
        XCTAssertEqual(encoder.name, name)
        guard let encodedUnit = Unit(rawValue: encoder.unit) else {
            XCTFail("Merch's unit failed to encode")
            return
        }
        XCTAssertEqual(encodedUnit, unit)
        XCTAssertEqual(UInt(encoder.numUses), numUses)
        XCTAssertEqual(encoder.lastUsed, lastUsed)
    }
}

class MockMerchDecoder : NSCoder 
{
    var fullyDecoded: Bool { return self.decodedKeys == Set(self.info.keys) }
    var decodedKeys: Set<String> = []
    var info: [String : AnyObject] = ["name" : "Broccoli",
                                      "unit" : "Head",
                                      "numUses" : 17,
                                      "lastUsed" : NSDate.distantFuture()]
    
    var name: String { return self.info["name"] as! String }
    var unit: String { return self.info["unit"] as! String }
    var numUses: Int { return self.info["numUses"] as! Int }
    var lastUsed: NSDate { return self.info["lastUsed"] as! NSDate }
    
    override func decodeObjectForKey(key: String) -> AnyObject?
    {
        self.decodedKeys.insert(key)
        return self.info[key]
    }
    
    override func decodeIntegerForKey(key: String) -> Int
    {
        self.decodedKeys.insert(key)
        return (self.info[key] as? Int) ?? 0
    }
}

class MockMerchEncoder : NSCoder
{
    var fullyEncoded: Bool { return self.encodedKeys == Set(self.info.keys) }
    var encodedKeys: Set<String> = []
    var info: [String : AnyObject] = [:]
    
    var name: String { return self.info["name"] as! String }
    var unit: String { return self.info["unit"] as! String }
    var numUses: Int { return self.info["numUses"] as! Int }
    var lastUsed: NSDate { return self.info["lastUsed"] as! NSDate }
    
    override func encodeObject(object: AnyObject?, forKey key: String)
    {
        self.encodedKeys.insert(key)
        self.info[key] = object
    }
    
    override func encodeInteger(integer: Int, forKey key: String)
    {
        self.encodedKeys.insert(key)
        self.info[key] = integer
    }
}
