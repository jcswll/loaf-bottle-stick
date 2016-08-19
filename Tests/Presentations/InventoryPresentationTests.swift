import XCTest
@testable import LoafBottleStickKit

class InventoryPresentationTests : XCTestCase
{
    let inventory: MarketList<Merch> = MarketList(items: Set(Merch.dummies))
    var presentation: InventoryPresentation!

    override func setUp()
    {
        self.presentation = InventoryPresentation(inventory: self.inventory)
        self.presentation.sortKey = .Name
    }

    //MARK: Sorting
    func testPresentsListSorted()
    {
        let sortKeys: [Merch.SortKey] = [.Name, .Date, .Uses]
        for sortKey in sortKeys
        {
            let comparator = Merch.comparator(forKey: sortKey)
            let sortedNames = self.inventory.items.sort(comparator)
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
        let newSortKey: Merch.SortKey = .Uses
        var sentDidChangeOrder = false
        self.presentation.didUpdate = { sentDidChangeOrder = true }

        self.presentation.sortKey = newSortKey

        XCTAssertTrue(sentDidChangeOrder)
    }

    //MARK: Addition
    func testCanAdd()
    {
        let addition = Merch.offListDummy

        assertNoThrow(try self.presentation.add(addition))

        let subPresentations = self.presentation.subPresentations
        let containsPresentation = subPresentations.contains {
                                       $0.name == addition.name
                                   }
        XCTAssertTrue(containsPresentation)
    }

    func testIsSortedAfterAdd()
    {
        let addition = Merch.offListDummy
        let sortedNames = (self.inventory.items + [addition])
                            .map { $0.name }
                            .sort((<))

        _ = try? self.presentation.add(addition)

        XCTAssertEqual(sortedNames,
                       self.presentation.subPresentations.map {
                               $0.name
                       })
    }

    func testNotifiesViewAfterAdd()
    {
        let addition = Merch.offListDummy
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

        self.presentation.deleteMerch(atIndex: deleteIdx)

        XCTAssertFalse(self.presentation.subPresentations.contains {
                           $0.name == deleted.name
                       })
    }

    func testNotifiesViewOnDelete()
    {
        let deleteIdx = 3
        var sentDidUpdate = false
        self.presentation.didUpdate = { sentDidUpdate = true }

        self.presentation.deleteMerch(atIndex: deleteIdx)

        XCTAssertTrue(sentDidUpdate)
    }


    func testNotifiesParentOnDelete()
    {
        let deleteIdx = 3
        let nameToDelete = self.presentation.subPresentations[deleteIdx].name
        var updatedInventory: MarketList<Merch>?
        var deletedMerch: Merch?
        self.presentation.didDeleteMerch = {
            (inventory, merch) in
                updatedInventory = inventory
                deletedMerch = merch
        }

        self.presentation.deleteMerch(atIndex: deleteIdx)

        stopOnFailure { XCTAssertNotNil(updatedInventory) }
        stopOnFailure { XCTAssertNotNil(deletedMerch) }
        // swiftlint:disable force_unwrapping
        XCTAssertEqual(nameToDelete, deletedMerch!.name)
        XCTAssertNil(updatedInventory!.item(forKey: deletedMerch!.searchKey))
        // swiftlint:enable force_unwrapping
    }
}
