import XCTest
@testable import LoafBottleStickKit

class MarketListTests : XCTestCase
{
    //MARK: Initialization
    func testCanInitializeEmpty()
    {
        let list = MarketList<Merch>()

        XCTAssert(list.items.isEmpty)
    }

    func testCanInitializeWithItems()
    {
        let contents = Set(Merch.dummies)

        let list = MarketList(items: contents)

        XCTAssertEqual(contents, list.items)
    }

    //MARK: Addition
    func testCanAdd()
    {
        let merch = Merch.dummy
        let contents: Set<Merch> = [merch]
        let addition = Merch.offListDummy

        var list = MarketList(items: contents)

        assertNoThrow(try list.add(addition))
        XCTAssertNotNil(list.item(forKey: addition.searchKey))
    }

    func testCannotAddExisting()
    {
        let merch = Merch.dummies[0]
        let contents = Set(Merch.dummies)

        var list = MarketList<Merch>(items: contents)

        XCTAssertThrowsError(try list.add(merch))
    }

    //MARK: Deletion
    func testCanDelete()
    {
        let merch = Merch.dummy
        let contents: Set<Merch> = [merch]

        var list = MarketList(items: contents)

        assertNoThrow(try list.delete(merch))

        XCTAssert(list.items.isEmpty)
    }

    func testCannotDeleteFromEmpty()
    {
        var list = MarketList<Merch>()

        XCTAssertThrowsError(try list.delete(Merch.dummy))
    }

    func testCannotDeleteNonexistent()
    {
        let contents: Set<Merch> = Set(Merch.dummies)
        let needle = Merch.offListDummy

        var list = MarketList(items: contents)

        XCTAssertThrowsError(try list.delete(needle))
        XCTAssertFalse(list.items.isEmpty)
    }

    func testCanDeleteFromMany()
    {
        var contents = Set(Merch.dummies)

        var list = MarketList(items: contents)
        //swiftlint:disable:next force_unwrapping
        let needle = contents.popFirst()!

        assertNoThrow(try list.delete(needle))
        XCTAssertEqual(contents, list.items)
    }

    func testCannotDeleteNonexistentFromMany()
    {
        let contents = Set(Merch.dummies)
        let needle = Merch.offListDummy

        var list = MarketList(items: contents)

        XCTAssertThrowsError(try list.delete(needle))
        XCTAssertEqual(contents, list.items)
    }

    //MARK: Updating
    func testUpdateDoesInsertNew()
    {
        let original = Merch.dummy
        let contents: Set<Merch> = [original]
        let replacement = Merch.offListDummy

        var list = MarketList(items: contents)

        assertNoThrow(try list.update(original, to: replacement))
        let retrieved = list.item(forKey: replacement.searchKey)
        stopOnFailure { XCTAssertNotNil(retrieved) }
        //swiftlint:disable:next force_unwrapping
        XCTAssertEqual(replacement, retrieved!)
    }

    func testUpdateDoesRemoveOld()
    {
        let original = Merch.dummy
        let contents: Set<Merch> = [original]
        let replacement = Merch.offListDummy

        var list = MarketList(items: contents)
        _ = try? list.update(original, to: replacement)
        let found = list.item(forKey: original.searchKey)

        XCTAssertNil(found)
    }

    func testCannotUpdateNonexistent()
    {
        let original = Merch.dummy
        let contents: Set<Merch> = [original]
        let replacement = Merch.offListDummy
        let nonexistent = Merch(name: "", unit: .Each)

        var list = MarketList(items: contents)

        XCTAssertThrowsError(try list.update(nonexistent, to: replacement))
    }

    func testUpdateAmongMany()
    {
        let contents = Set(Merch.dummies)
        //swiftlint:disable:next force_unwrapping
        let needle = contents.first!
        let replacement = Merch.offListDummy

        var list = MarketList(items: contents)
        _ = try? list.update(needle, to: replacement)
        let retrieved = list.item(forKey: replacement.searchKey)
        let needleRetrieved = list.item(forKey: needle.searchKey)

        XCTAssertEqual(retrieved, replacement)
        XCTAssertNil(needleRetrieved)
    }

    func testCannotUpdateNonexistentAmongMany()
    {
        let contents = Set(Merch.dummies)
        let needle = Merch.offListDummy

        var list = MarketList(items: contents)

        XCTAssertThrowsError(try list.update(needle, to: Merch.dummy))
    }

    //MARK: Search
    func testSearch()
    {
        let merch = Merch.dummy
        let contents: Set<Merch> = [merch]

        let list = MarketList(items: contents)
        let found = list.item(forKey: merch.searchKey)

        XCTAssertEqual(merch, found)
    }

    func testSearchFindsNothingInEmptyList()
    {
        let merch = Merch.dummy

        let list = MarketList<Merch>()
        let found = list.item(forKey: merch.searchKey)

        XCTAssertNil(found)
    }

    func testSearchMany()
    {
        let contents = Set(Merch.dummies)
        //swiftlint:disable:next force_unwrapping
        let needle = contents.first!

        let list = MarketList(items: contents)
        let found = list.item(forKey: needle.searchKey)

        XCTAssertEqual(needle, found)
    }

    func testSearchDoesNotFindNonexistent()
    {
        let contents = Set(Merch.dummies)
        let needle = Merch.offListDummy

        let list = MarketList(items: contents)
        let found = list.item(forKey: needle.searchKey)

        XCTAssertNil(found)
    }

    //MARK: Search key merch
    func testMerchIsUsed()
    {
        let merch = Merch.dummy
        let unusedMerch = Merch.offListDummy
        let purchase = Purchase(merch: merch, quantity: 0)
        let contents: Set<Purchase> = [purchase]

        let list = MarketList(items: contents)

        XCTAssertTrue(list.merchIsUsed(merch))
        XCTAssertFalse(list.merchIsUsed(unusedMerch))
    }
}
