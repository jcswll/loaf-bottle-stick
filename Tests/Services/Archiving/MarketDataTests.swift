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

        guard let data = MarketData(coder: decoder) else {
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
        data.encodeWithCoder(encoder)

        // All expected keys, and *only* expected keys, encoded
        XCTAssert(encoder.fullyEncoded,
                  "Actual and expected encoding keys do not match.\n" +
                  "Expected \(encoder.encodedKeys)\n" +
                  "Have \(Array(encoder.info.keys))")

        // All data present and correct
        stopOnFailure{ XCTAssertNotNil(encoder.name) }
        XCTAssertEqual(encoder.name!, name)
        stopOnFailure { XCTAssertNotNil(encoder.ident) }
        XCTAssertEqual(encoder.ident!, ident)
        stopOnFailure { XCTAssertNotNil(encoder.inventory) }
        XCTAssertEqual(encoder.inventory!.marketList, inventory)
        stopOnFailure { XCTAssertNotNil(encoder.trip) }
        XCTAssertEqual(encoder.trip!.marketList, trip)
    }
}

class MockMarketDecoder : NSCoder
{
    var fullyDecoded: Bool { 
        return self.decodedKeys.sort() == self.info.keys.sort()
    }
    var decodedKeys: [String] = []
    var info: [String : AnyObject] =
            ["name" : "Abbandando's Groceria",
             "ident" : "ABCD-1234",
             "inventory" : MarketListData<Merch, MerchData>(MarketList()),
             "trip" : MarketListData<Purchase, PurchaseData>(MarketList())]

    var name: String { return self.info["name"] as! String }
    var ident: String { return self.info["ident"] as! String }
    var inventory: MarketListData<Merch, MerchData> { 
        return self.info["inventory"] as! MarketListData<Merch, MerchData>
    }
    var trip: MarketListData<Purchase, PurchaseData> { 
        return self.info["trip"] as! MarketListData<Purchase, PurchaseData>
    }

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
}

class MockMarketEncoder : NSCoder
{
    var fullyEncoded: Bool {
        return self.encodedKeys.sort() == self.info.keys.sort()
    }
    var encodedKeys: [String] = ["name", "ident", "inventory", "trip"]
    var info: [String : AnyObject] = [:]

    var name: String? { return self.info["name"] as? String }
    var ident: String? { return self.info["ident"] as? String }
    var inventory: MarketListData<Merch, MerchData>? {
        return self.info["inventory"] as? MarketListData<Merch, MerchData>
    }
    var trip: MarketListData<Purchase, PurchaseData>? {
        return self.info["trip"] as? MarketListData<Purchase, PurchaseData>
    }

    override func encodeObject(object: AnyObject?, forKey key: String)
    {
        self.info[key] = object
    }

    override func encodeInteger(integer: Int, forKey key: String)
    {
        self.info[key] = integer
    }
}
