import XCTest
@testable import LoafBottleStickKit

class TripPresentationTests : XCTestCase
{
    let trip: MarketList<Purchase> = MarketList(items: Set(Purchase.dummies))
    var presentation: TripPresentation!

    override func setUp()
    {
        self.presentation = TripPresentation(trip: self.trip)
        self.presentation.sortKey = .Name
    }

    //MARK: Sorting
    func testPresentsListSorted()
    {
        let sortKeys: [Purchase.SortKey] = [.Name, .Date, .Uses]
        for sortKey in sortKeys
        {
            let comparator = Purchase.comparator(forKey: sortKey)
            let sortedNames = self.trip.items.sort(comparator)
                                             .map { $0.name }

            self.presentation.sortKey = sortKey

            XCTAssertEqual(sortedNames,
                           self.presentation.subPresentations.map {
                                   $0.name
                           })
        }
    }

    func testNotifiesViewOnChangeOrder()
    {
        let newSortKey: Purchase.SortKey = .Uses
        var sentDidChangeOrder = false
        self.presentation.didUpdate = { sentDidChangeOrder = true }

        self.presentation.sortKey = newSortKey

        XCTAssertTrue(sentDidChangeOrder)
    }

    //MARK: Addition
    func testCanAdd()
    {
        let addition = Purchase.offListDummy

        assertNoThrow(try self.presentation.add(addition))

        let subPresentations = self.presentation.subPresentations
        let containsPresentation = subPresentations.contains {
                                       $0.name == addition.name
                                   }
        XCTAssertTrue(containsPresentation)
    }

    func testIsSortedAfterAdd()
    {
        let addition = Purchase.offListDummy
        let sortedNames = (self.trip.items + [addition]).map { $0.name }
                                                        .sort((<))

        _ = try? self.presentation.add(addition)

        XCTAssertEqual(sortedNames,
                       self.presentation.subPresentations.map {
                               $0.name
                       })
    }

    func testNotifiesViewAfterAdd()
    {
        let addition = Purchase.offListDummy
        var sentDidUpdate = false
        self.presentation.didUpdate = { sentDidUpdate = true }

        _ = try? self.presentation.add(addition)

        XCTAssertTrue(sentDidUpdate)
    }

    //MARK: Deletion
    func testCanDelete()
    {
        let deleteIdx = 3
        let deleted = self.presentation.subPresentations[deleteIdx]

        self.presentation.deletePurchase(atIndex: deleteIdx)

        XCTAssertFalse(self.presentation.subPresentations.contains {
                           $0.name == deleted.name
                       })
    }

    func testNotifiesViewOnDelete()
    {
        let deleteIdx = 3
        var sentDidUpdate = false
        self.presentation.didUpdate = { sentDidUpdate = true }

        self.presentation.deletePurchase(atIndex: deleteIdx)

        XCTAssertTrue(sentDidUpdate)
    }

    func testNotifiesParentOnDelete()
    {
        let deleteIdx = 3
        let nameToDelete = self.presentation.subPresentations[deleteIdx].name
        var updatedTrip: MarketList<Purchase>?
        var deletedPurchase: Purchase?
        self.presentation.didDeletePurchase = { (trip, purchase) in
            
            updatedTrip = trip
            deletedPurchase = purchase
        }

        self.presentation.deletePurchase(atIndex: deleteIdx)

        stopOnFailure { XCTAssertNotNil(updatedTrip) }
        stopOnFailure { XCTAssertNotNil(deletedPurchase) }
        // swiftlint:disable force_unwrapping
        XCTAssertEqual(nameToDelete, deletedPurchase!.name)
        let key = deletedPurchase!.searchKey
        XCTAssertNil(updatedTrip!.item(forKey: key))
        // swiftlint:enable force_unwrapping
    }

    //MARK: Splitting
    func checkedAndUncheckedPurchases() -> [Purchase]
    {
        return [Purchase(merch: Merch(name: "Bananas", unit: nil)),
                Purchase(merch: Merch(name: "Broccoli", unit: nil)),
                Purchase(merch: Merch(name: "Carrots", unit: nil)),
                Purchase(merch: Merch(name: "Eggs", unit: nil)),
                //swiftlint:disable line_length
                Purchase(merch: Merch(name: "Apples", unit: nil)).checkingOff(),
                Purchase(merch: Merch(name: "Quince", unit: nil)).checkingOff()]
                //swiftlint:enable line_length
    }

    func testSplitting()
    {
        let purchases = self.checkedAndUncheckedPurchases()
        let trip = MarketList(items: Set(purchases))
        let presentation = TripPresentation(trip: trip)

        presentation.separateCheckedItems = true

        XCTAssertEqual(purchases.map { $0.name },
                       presentation.subPresentations.map { $0.name })
    }

    func testNotifiesViewWhenChangingSplitting()
    {
        var sentDidUpdate = false
        self.presentation.didUpdate = { sentDidUpdate = true }

        self.presentation.separateCheckedItems = true

        XCTAssertTrue(sentDidUpdate)
    }
}
