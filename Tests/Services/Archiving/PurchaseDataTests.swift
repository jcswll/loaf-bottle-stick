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
                  "Expected \(encoder.expectedKeys)\n" +
                  "Have \(Array(encoder.actualKeys))")

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

final class MockPurchaseDecoder : MockDecoder
{
    override var info: [String : AnyObject] {
        return ["merch" : MerchData(item: Merch.dummy),
                "note" : "Get the organic stuff", 
                "quantity" : 3, 
                "checkedOff" : true]
    }
    
    var merch: MerchData { return self.info["merch"] as! MerchData }
    var note: String { return self.info["note"] as! String }
    var quantity: UInt { return self.info["quantity"] as! UInt }
    var isCheckedOff: Bool { return self.info["checkedOff"] as! Bool }
}

final class MockPurchaseEncoder : MockEncoder
{
    override var expectedKeys: [String] {
        return ["merch", "note", "quantity", "checkedOff"]
    }

    var merch: MerchData? { return self.info["merch"] as? MerchData }
    var note: String? { return self.info["note"] as? String }
    var quantity: Int? { return self.info["quantity"] as? Int }
    var isCheckedOff: Bool? { return self.info["checkedOff"] as? Bool }
}