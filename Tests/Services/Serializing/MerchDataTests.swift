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
        //swiftlint:disable:next force_unwrapping
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
                  "Expected \(encoder.expectedKeys)\n" +
                  "Have \(Array(encoder.actualKeys))")

        // All data present and correct
        // swiftlint:disable force_unwrapping
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
        // swiftlint:enable force_unwrapping
    }
}

final class MockMerchDecoder : MockDecoder
{
    override var info: [String : AnyObject] {
        return ["name" : "Broccoli",
                "unit" : "Head",
                "numUses" : 17,
                "lastUsed" : NSDate.distantFuture()]
    }

    // swiftlint:disable force_cast
    var name: String { return self.info["name"] as! String }
    var unit: String { return self.info["unit"] as! String }
    var numUses: Int { return self.info["numUses"] as! Int }
    var lastUsed: NSDate { return self.info["lastUsed"] as! NSDate }
}

final class MockMerchEncoder : MockEncoder
{
    override var expectedKeys: [String] {
        return ["name", "unit", "numUses", "lastUsed"]
    }

    var name: String? { return self.info["name"] as? String }
    var unit: String? { return self.info["unit"] as? String }
    var numUses: Int? { return self.info["numUses"] as? Int }
    var lastUsed: NSDate? { return self.info["lastUsed"] as? NSDate }
}
