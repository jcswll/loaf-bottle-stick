import XCTest
@testable import LoafBottleStickKit

class MarketListDataTests : XCTestCase
{
    let merch = Merch.dummy

    func testHoldsData()
    {
        let items: Set<Merch> = [self.merch]

        let data = MarketListData<MerchData>(items: items)

         XCTAssertEqual(items, data.items)
    }

    func testCanConstructMarketList()
    {
        let items: Set<Merch> = [self.merch]

        let data = MarketListData<MerchData>(items: items)
        let list = data.marketList

        XCTAssertEqual(Set(items), list.items)
    }

    func testCanDecomposeMarketList()
    {
        let items: Set<Merch> = [self.merch]

        let list = MarketList(items: items)
        let data = MarketListData<MerchData>(list)

        XCTAssertEqual(items, data.items)
    }

    func testDecodesFullyAndCorrectly()
    {
        let decoder = MockMarketListDecoder()

        guard let data = MarketListData<MerchData>(decoder: decoder) else {
            XCTFail("Could not construct MarketList from decoder.")
            return
        }

        // All expected keys, and *only* expected keys, decoded
        XCTAssert(decoder.fullyDecoded,
                  "Actual and expected decoding keys do not match.\n" +
                  "Expected \(decoder.decodedKeys)\n" +
                  "Have \(Array(decoder.info.keys))")

        let decoderItems = Set<Merch>(decoder.items.map { $0.item  })

        // All data correct
        XCTAssertEqual(decoderItems, data.items)
    }

    func testEncodesFullyAndCorrectly()
    {
        let encoder = MockMarketListEncoder()
        let items: Set<Merch> = [self.merch]

        let data = MarketListData<MerchData>(items: items)

        data.encode(withEncoder: encoder)

        // All expected keys, and *only* expected keys, encoded
        XCTAssert(encoder.fullyEncoded,
                  "Actual and expected encoding keys do not match.\n" +
                  "Expected \(encoder.expectedKeys)\n" +
                  "Have \(Array(encoder.info.keys))")

        // All data present and correct
        // swiftlint:disable force_unwrapping
        stopOnFailure { XCTAssertNotNil(encoder.items) }
        let encoderItems = Set<Merch>(encoder.items!.map { $0.item })
        XCTAssertEqual(encoderItems, items)
        // swiftlint:enable force_unwrapping
    }
}

class MockMarketListDecoder : MockDecoder
{
    override var info: [String : AnyObject] {
        return ["items" : [MerchData(item: Merch.dummy),
                           MerchData(item: Merch.dummy)]]
    }
    // swiftlint:disable force_cast
    var items: [MerchData] { return self.info["items"] as! [MerchData] }
    // swiftlint:enable force_cast
}

class MockMarketListEncoder : MockEncoder
{
    override var expectedKeys: [String] { return ["items"] }

    var items: [MerchData]? { return self.info["items"] as? [MerchData] }
}
