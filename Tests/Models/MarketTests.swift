import XCTest
@testable import LoafBottleStickKit

class MarketTests : XCTestCase
{
    //MARK: Initialization
    func testInitalizesEmpty()
    {
        let name = "Abbandando's Groceria"
        let market = Market(name: name)
        
        XCTAssertEqual(name, market.name)
        XCTAssertFalse(market.ident.isEmpty)
        XCTAssert(market.inventory.items.isEmpty)
        XCTAssert(market.trip.items.isEmpty)
    }
    
    func testDistinctIdentsForEqualNames()
    {
        let name = "Abbandando's Groceria"
        let first = Market(name: name)
        let second = Market(name: name)
        
        XCTAssertNotEqual(first.ident, second.ident)
    }
}
