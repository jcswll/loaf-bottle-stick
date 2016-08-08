import XCTest
@testable import LoafBottleStickKit

class MarketListDataTests : XCTestCase
{
    let merch = Merch.dummy
    
    func testHoldsData()
    {
        let items: Set<Merch> = [self.merch, self.merch]

        let data = MarketListData(items: items)

         XCTAssertEqual(items, data.items)
    }

    func testCanConstructMarketList()
    {
        let items: Set<Merch> = [self.merch, self.merch]

        let data = MarketListData(items: items)
        let list = data.marketList

        XCTAssertEqual(Set(items), list.items)
    }
    
    func testCanDecomposeMarketList()
    {
        let items: Set<Merch> = [self.merch, self.merch]

        let list = MarketList(items: items)
        let data = MarketListData(list)

        XCTAssertEqual(items, data.items)
    }

    func testDecodesFullyAndCorrectly()
    {
        let decoder = MockMarketListDecoder()

        guard let data = MarketListData<Merch, MerchData>(coder: decoder) else {
            XCTFail("Could not construct MarketList from decoder.")
            return
        }

        // All expected keys, and *only* expected keys, decoded
        XCTAssert(decoder.fullyDecoded, 
                  "Actual and expected decoding keys do not match.\n" + 
                  "Expected \(decoder.decodedKeys)\n" +
                  "Have \(Array(decoder.info.keys))")
        
        let decoderItems = Set<Merch>(decoder.items.map { Merch(data: $0) })

        // All data correct
        XCTAssertEqual(decoderItems, data.items)
    }

    func testEncodesFullyAndCorrectly()
    {
        let encoder = MockMarketListEncoder()
        let items: Set<Merch> = [self.merch, self.merch]

        let data = MarketListData(items: items)

        data.encodeWithCoder(encoder)

        // All expected keys, and *only* expected keys, encoded
        XCTAssert(encoder.fullyEncoded,
                  "Actual and expected encoding keys do not match.\n" +
                  "Expected \(encoder.encodedKeys)\n" +
                  "Have \(Array(encoder.info.keys))")

        // All data present and correct
        stopOnFailure { XCTAssertNotNil(encoder.items) }
        let encoderItems = Set<Merch>(encoder.items!.map { Merch(data: $0) })
        XCTAssertEqual(encoderItems, items)
    }
}

class MockMarketListDecoder : NSCoder
{
    var fullyDecoded: Bool { 
        return self.decodedKeys.sort() == self.info.keys.sort()
    }
    var decodedKeys: [String] = []
    let info: [String : AnyObject] = ["items" : 
                                        [MerchData(item: Merch.dummy), 
                                         MerchData(item: Merch.dummy)]]

    var items: [MerchData] { return self.info["items"] as! [MerchData] }

    override func decodeObjectForKey(key: String) -> AnyObject?
    {
        self.decodedKeys.append(key)
        return self.info[key]
    }
}

class MockMarketListEncoder : NSCoder
{
    var fullyEncoded: Bool { 
        return self.encodedKeys.sort() == self.info.keys.sort()
    }
    var encodedKeys: [String] = ["items"]
    var info: [String : AnyObject] = [:]

    var items: [MerchData]? { return self.info["items"] as? [MerchData] }

    override func encodeObject(object: AnyObject?, forKey key: String)
    {
        self.info[key] = object
    }
}
