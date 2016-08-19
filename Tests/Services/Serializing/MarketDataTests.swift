import XCTest
@testable import LoafBottleStickKit

class MarketDataTests : XCTestCase
{
    func testHoldsData()
    {
        let name = "Abbandando's Groceria"
        let ident = "ABCD-1234"
        let inventory = MarketList<Merch>()
        let trip = MarketList<Purchase>()

        let data = MarketData(name: name,
                             ident: ident,
                          inventory: inventory,
                         trip: trip)

         XCTAssertEqual(name, data.name)
         XCTAssertEqual(ident, data.ident)
         XCTAssertEqual(inventory, data.inventory)
         XCTAssertEqual(trip, data.trip)
    }

    func testCanConstructMarket()
    {
        let name = "Abbandando's Groceria"
        let ident = "ABCD-1234"
        let inventory = MarketList<Merch>()
        let trip = MarketList<Purchase>()

        let data = MarketData(name: name,
                             ident: ident,
                         inventory: inventory,
                              trip: trip)
        let market = data.market

        XCTAssertEqual(name, market.name)
        XCTAssertEqual(ident, market.ident)
        XCTAssertEqual(inventory, market.inventory)
        XCTAssertEqual(trip, market.trip)
    }

    func testCanDecomposeMarket()
    {
        let name = "Abbandando's Groceria"
        let ident = "ABCD-1234"
        let inventory = MarketList<Merch>()
        let trip = MarketList<Purchase>()

        let market = Market(name: name,
                           ident: ident,
                       inventory: inventory,
                            trip: trip)
        let data = MarketData(market)

        XCTAssertEqual(name, data.name)
        XCTAssertEqual(ident, data.ident)
        XCTAssertEqual(inventory, data.inventory)
        XCTAssertEqual(trip, data.trip)
    }

    func testDecodesFullyAndCorrectly()
    {
        let decoder = MockMarketDecoder()

        guard let data = MarketData(decoder: decoder) else {
            XCTFail("Could not construct Market from decoder.")
            return
        }

        // All expected keys, and *only* expected keys, decoded
        XCTAssert(decoder.fullyDecoded,
                  "Actual and expected decoding keys do not match.\n" +
                  "Expected \(decoder.decodedKeys)\n" +
                  "Have \(Array(decoder.info.keys))")

        let inventory = decoder.inventory.marketList
        let trip = decoder.trip.marketList

        // All data correct
        XCTAssertEqual(decoder.name, data.name)
        XCTAssertEqual(decoder.ident, data.ident)
        XCTAssertEqual(inventory, data.inventory)
        XCTAssertEqual(trip, data.trip)
    }

    func testEncodesFullyAndCorrectly()
    {
        let encoder = MockMarketEncoder()
        let name = "Abbandando's Groceria"
        let ident = "ABCD-1234"
        let inventory = MarketList<Merch>()
        let trip = MarketList<Purchase>()

        let data = MarketData(name: name,
                             ident: ident,
                         inventory: inventory,
                              trip: trip)
        data.encode(withEncoder: encoder)

        // All expected keys, and *only* expected keys, encoded
        XCTAssert(encoder.fullyEncoded,
                  "Actual and expected encoding keys do not match.\n" +
                  "Expected \(encoder.expectedKeys)\n" +
                  "Have \(Array(encoder.info.keys))")

        // All data present and correct
        stopOnFailure{ XCTAssertNotNil(encoder.name) }
        //swiftlint:disable force_unwrapping
        XCTAssertEqual(encoder.name!, name)
        stopOnFailure { XCTAssertNotNil(encoder.ident) }
        XCTAssertEqual(encoder.ident!, ident)
        stopOnFailure { XCTAssertNotNil(encoder.inventory) }
        XCTAssertEqual(encoder.inventory!.marketList, inventory)
        stopOnFailure { XCTAssertNotNil(encoder.trip) }
        XCTAssertEqual(encoder.trip!.marketList, trip)
        //swiftlint:enable force_unwrapping
    }
}

class MockMarketDecoder : MockDecoder
{
    override var info: [String : AnyObject] {
            return ["name" : "Abbandando's Groceria",
                    "ident" : "ABCD-1234",
                    "inventory" : MarketListData<MerchData>(MarketList()),
                    "trip" : MarketListData<PurchaseData>(MarketList())]
    }

    //swiftlint:disable force_cast
    var name: String { return self.info["name"] as! String }
    var ident: String { return self.info["ident"] as! String }
    var inventory: MarketListData<MerchData> {
        return self.info["inventory"] as! MarketListData<MerchData>
    }
    var trip: MarketListData<PurchaseData> {
        return self.info["trip"] as! MarketListData<PurchaseData>
    }
    //swiftlint:enable force_cast
}

class MockMarketEncoder : MockEncoder
{
    override var expectedKeys: [String] {
        return ["name", "ident", "inventory", "trip"]
    }

    var name: String? { return self.info["name"] as? String }
    var ident: String? { return self.info["ident"] as? String }
    var inventory: MarketListData<MerchData>? {
        return self.info["inventory"] as? MarketListData<MerchData>
    }
    var trip: MarketListData<PurchaseData>? {
        return self.info["trip"] as? MarketListData<PurchaseData>
    }
}
