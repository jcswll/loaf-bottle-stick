import XCTest
@testable import LoafBottleStickKit

class MarketPresentationTests : XCTestCase
{
    let inventory = MarketList(items: Set(Merch.dummies))
    let trip = MarketList(items: Set(Purchase.dummies))
    var market: Market!
    var presentation: MarketPresentation!


    override func setUp()
    {
        self.market = Market(name: "Abbandando's Groceria",
                            ident: "",
                        inventory: self.inventory,
                             trip: self.trip)
        self.presentation = MarketPresentation(market: self.market)
    }

    func testPresentsName()
    {
        XCTAssertEqual(self.market.name, self.presentation.name)
    }

    func testNotifiesViewOnNameChange()
    {
        var sentDidUpdate = false
        self.presentation.didUpdate = { sentDidUpdate = true }

        self.presentation.name = "Genco Olive Oil Co."

        XCTAssertTrue(sentDidUpdate)
    }

    func testPresentsInventory()
    {
        let inventoryPresentation = self.presentation.inventoryPresentation
        let expectedNames = Set(self.inventory.items.map { $0.name })
        let names = Set(inventoryPresentation.subPresentations
                                             .map { $0.name })

        XCTAssertEqual(expectedNames, names)
    }

    func testPresentsTrip()
    {
        let tripPresentation = self.presentation.tripPresentation
        let expectedNames = Set(self.trip.items.map { $0.name })
        let names = Set(tripPresentation.subPresentations.map { $0.name })

        XCTAssertEqual(expectedNames, names)
    }
}
