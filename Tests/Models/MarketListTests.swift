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
        let contents: Set<Merch> = [Merch.dummy]
        
        let list = MarketList(items: contents)
        
        XCTAssertEqual(contents, list.items)
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
        let contents: Set<Merch> = [Merch.dummy]
        let needle = Merch(name: "Milk", unit: .Gallon)
        
        var list = MarketList(items: contents)
        
        XCTAssertThrowsError(try list.delete(needle))
        XCTAssertFalse(list.items.isEmpty)
    }
    
    func testCanDeleteFromMany()
    {
        let names = ["Broccoli", "Bananas", "Carrots", "Apples", "Quince"]
        var contents = Set(names.map { Merch(name: $0, unit: nil) })

        var list = MarketList(items: contents)
        let needle = contents.popFirst()!

        assertNoThrow(try list.delete(needle))
        XCTAssertEqual(contents, list.items)
    }
    
    func testCannotDeleteNonexistentFromMany()
    {
        let names = ["Broccoli", "Bananas", "Carrots", "Apples", "Quince"]
        let contents = Set(names.map { Merch(name: $0, unit: nil) })
        let needle = Merch(name: "Milk", unit: .Gallon)
        
        var list = MarketList(items: contents)
        
        XCTAssertThrowsError(try list.delete(needle))
        XCTAssertEqual(contents, list.items)
    }
    
    //MARK: Updating
    func testUpdateDoesInsertNew()
    {
        let original = Merch.dummy
        let contents: Set<Merch> = [original]
        let replacement = Merch(name: "Milk", unit: .Gallon)
        
        var list = MarketList(items: contents)
        
        assertNoThrow(try list.update(original, to: replacement))
        let retrieved = list.item(forKey: replacement.searchKey)
        XCTAssertEqual(replacement, retrieved!)
    }
    
    func testUpdateDoesRemoveOld()
    {
        let original = Merch.dummy
        let contents: Set<Merch> = [original]
        let replacement = Merch(name: "Milk", unit: .Gallon)
        
        var list = MarketList(items: contents)
        _ = try? list.update(original, to: replacement)
        let found = list.item(forKey: original.searchKey)
        
        XCTAssertNil(found)
    }
    
    func testCannotUpdateNonexistent()
    {
        let original = Merch.dummy
        let contents: Set<Merch> = [original]
        let replacement = Merch(name: "Milk", unit: .Gallon)
        let nonexistent = Merch(name: "", unit: .Each)
        
        var list = MarketList(items: contents)
        
        XCTAssertThrowsError(try list.update(nonexistent, to: replacement))
    }
    
    func testUpdateAmongMany()
    {
        let names = ["Broccoli", "Bananas", "Carrots", "Apples", "Quince"]
        let contents = Set(names.map { Merch(name: $0, unit: nil) })
        let needle = contents.first!
        let replacement = Merch(name: "Milk", unit: .Gallon)
        
        var list = MarketList(items: contents)
        _ = try? list.update(needle, to: replacement)
        let retrieved = list.item(forKey: replacement.searchKey)
        let needleRetrieved = list.item(forKey: needle.searchKey)
        
        XCTAssertEqual(retrieved, replacement)
        XCTAssertNil(needleRetrieved)
    }
    
    func testCannotUpdateNonexistentAmongMany()
    {
        let names = ["Broccoli", "Bananas", "Carrots", "Apples", "Quince"]
        let contents = Set(names.map { Merch(name: $0, unit: nil) })
        let needle = Merch(name: "Milk", unit: .Gallon)
        
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
        let names = ["Broccoli", "Bananas", "Carrots", "Apples", "Quince"]
        let contents = Set(names.map { Merch(name: $0, unit: nil) })
        let needle = contents.first!
        
        let list = MarketList(items: contents)
        let found = list.item(forKey: needle.searchKey)
        
        XCTAssertEqual(needle, found)
    }
    
    func testSearchDoesNotFindNonexistent()
    {
        let names = ["Broccoli", "Bananas", "Carrots", "Apples", "Quince"]
        let contents = Set(names.map { Merch(name: $0, unit: nil) })
        let needle = Merch(name: "Milk", unit: .Gallon)
        
        let list = MarketList(items: contents)
        let found = list.item(forKey: needle.searchKey)
        
        XCTAssertNil(found)
    }
    
    //MARK: Search key merch
    func testMerchIsUsed()
    {
        let merch = Merch.dummy
        let unusedMerch = Merch(name: "Milk", unit: .Gallon)
        let purchase = Purchase(merch: merch, quantity: 0)
        let contents: Set<Purchase> = [purchase]
        
        let list = MarketList(items: contents)
        
        XCTAssertTrue(list.merchIsUsed(merch))
        XCTAssertFalse(list.merchIsUsed(unusedMerch))
    }
}
