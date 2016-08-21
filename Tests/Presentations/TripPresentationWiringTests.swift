import XCTest
@testable import LoafBottleStickKit

class TripPresentationWiringTests : XCTestCase
{
    let trip: MarketList<Purchase> = MarketList(items: Set(Purchase.dummies))
    var presentation: TripPresentation!

    override func setUp()
    {
        self.presentation = TripPresentation(trip: self.trip)
        self.presentation.sortKey = .Name
    }

    func testItemModified()
    {
        let purchasePresentation = self.presentation.subPresentations[0]
        let oldName = purchasePresentation.name
        let newName = Purchase.offListDummy.name

        purchasePresentation.name = newName

        let subPresentations = self.presentation.subPresentations
        XCTAssertTrue(subPresentations.contains { $0.name == newName })
        XCTAssertFalse(subPresentations.contains { $0.name == oldName })
    }

    func testNotifiesParentWhenItemModified()
    {
        let purchasePresentation = self.presentation.subPresentations[0]
        var sentDidChange = false
        self.presentation.purchaseDidChange = { (_, _) in
            sentDidChange = true
        }

        purchasePresentation.name = Purchase.offListDummy.name

        XCTAssertTrue(sentDidChange)
    }

    func testNotifiesViewWhenItemModified()
    {
        let purchasePresentation = self.presentation.subPresentations[0]
        var sentDidUpdate = false
        self.presentation.didUpdate = { sentDidUpdate = true }

        purchasePresentation.name = Purchase.offListDummy.name

        XCTAssertTrue(sentDidUpdate)
    }

    func testNotifiesParentAboutChangeToMerch()
    {
        let purchasePresentation = self.presentation.subPresentations[0]
        var sentDidChangeMerch = false
        self.presentation.merchDidChange = { (_, _) in
            sentDidChangeMerch = true
        }

        purchasePresentation.name = Purchase.offListDummy.name

        XCTAssertTrue(sentDidChangeMerch)
    }

    func testUpdatesOrderWhenItemModified()
    {
        let purchasePresentation = self.presentation.subPresentations[0]
        let oldName = purchasePresentation.name
        let newName = Purchase.offListDummy.name
        let sortedNames = Merch.dummyNames.map {
                                              $0 == oldName ? newName : $0
                                          }.sort((<))

        purchasePresentation.name = newName

        XCTAssertEqual(sortedNames,
                       self.presentation.subPresentations.map {
                               $0.name
                       })
    }

    func testNotifiesViewWhenTogglingChecked()
    {
        let purchasePresentation = self.presentation.subPresentations[0]
        var sentDidUpdate = false
        self.presentation.didUpdate = { sentDidUpdate = true }

        purchasePresentation.toggleChecked()

        XCTAssertTrue(sentDidUpdate)
    }
}
