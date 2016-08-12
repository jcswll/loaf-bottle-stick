import XCTest
@testable import LoafBottleStickKit

class MerchTests : XCTestCase
{
    let allowableSecondsDelta = 2.0
    
    //MARK: Basic functionality
    func testInitializes()
    {
        let name = "Broccoli"
        let unit = Unit.Head
        let numUses: UInt = 0    // New instance has never been used
        let lastUsed = NSDate.distantPast()
        
        let merch = Merch(name: name, unit: unit)
        
        XCTAssertEqual(name, merch.name)
        XCTAssertEqual(unit, merch.unit)
        XCTAssertEqual(numUses, merch.numUses)
        XCTAssertEqual(lastUsed, merch.lastUsed)
        
        // Default unit
        let merchNoUnit = Merch(name: name, unit: nil)
        XCTAssertEqual(Unit.Each, merchNoUnit.unit)
    }
    
    func testSearchesByName()
    {
        let name = "Broccoli"
        
        let merch = Merch(name: name, unit: nil)
        
        XCTAssertEqual(name, merch.searchKey)
    }
    
    //MARK: Mutation
    func testPurchaseSetsNumUsesAndDate()
    {
        let name = "Broccoli"

        let merch = Merch(name: name, unit: nil)
        let purchased = merch.purchasing()
        
        XCTAssertEqual(merch.numUses + 1, purchased.numUses)
        XCTAssertEqualWithAccuracy(0, purchased.lastUsed.timeIntervalSinceNow,
                                   accuracy: self.allowableSecondsDelta)
    }
    
    func testPurchasePreservesNameAndUnit()
    {
        let name = "Broccoli"
        let unit = Unit.Head
        
        let merch = Merch(name: name, unit: unit)
        let purchased = merch.purchasing()
        
        XCTAssertEqual(name, purchased.name)
        XCTAssertEqual(unit, purchased.unit)
    }
    
    func testChangingName()
    {
        let name = "Broccoli"
        let newName = "Milk"
        
        let renamed = Merch(name: name, unit: nil).changingName(to: newName)
        
        XCTAssertEqual(newName, renamed.name)
    }
    
    func testChangingNamePreservesOtherFields()
    {
        let name = "Broccoli"
        let unit = Unit.Head
        let newName = "Milk"
        
        let merch = Merch(name: name, unit: unit)
        let renamed = merch.changingName(to: newName)
        
        XCTAssertEqual(merch.unit, renamed.unit)
        XCTAssertEqual(merch.numUses, renamed.numUses)
        XCTAssertEqualWithAccuracy(merch.lastUsed.timeIntervalSinceNow,    
                                   renamed.lastUsed.timeIntervalSinceNow,
                                   accuracy: self.allowableSecondsDelta)
    }
    
    func testChangingUnit()
    {
        let name = "Broccoli"
        let unit = Unit.Head
        let newUnit = Unit.Box

        let changed = Merch(name: name, unit: unit).changingUnit(to: newUnit)

        XCTAssertEqual(newUnit, changed.unit)
    }
    
    func testChangingUnitPreservesOtherFields()
    {
        let name = "Broccoli"
        let unit = Unit.Head
        let newUnit = Unit.Box
        
        let merch = Merch(name: name, unit: unit)
        let changed = merch.changingUnit(to: newUnit)
        
        XCTAssertEqual(merch.name, changed.name)
        XCTAssertEqual(merch.numUses, changed.numUses)
        XCTAssertEqualWithAccuracy(merch.lastUsed.timeIntervalSinceNow,    
                                   changed.lastUsed.timeIntervalSinceNow,
                                   accuracy: self.allowableSecondsDelta)
    }
    
    //MARK: Sorting
    func testCanSortByName()
    {
        let names = Merch.dummyNames
        let merches = Merch.dummies
        
        let comparator = Merch.comparator(forKey: Merch.SortKey.Name)
        let sorted = merches.sort(comparator)
        
        XCTAssertEqual(names.sort((<)), sorted.map { $0.name })
    }
    
    func testCanSortByDate()
    {
        let intervals: [NSTimeInterval] = [4, 5, 6, 1, 3, 2, 7]
        let dates = intervals.map { NSDate(timeIntervalSince1970: $0) }
        let merches = dates.map { Merch(name: "", 
                                        unit: .Each,
                                     numUses: 0,
                                    lastUsed: $0) }
        
        let comparator = Merch.comparator(forKey: Merch.SortKey.Date)
        let sorted = merches.sort(comparator)
        
        XCTAssertEqual(intervals.sort((<)), 
                       sorted.map { $0.lastUsed.timeIntervalSince1970 })
    }
    
    func testCanSortByUses()
    {
        let uses: [UInt] = [4, 5, 6, 1, 3, 2, 7]
        let merches = uses.map { Merch(name: "", 
                                       unit: .Each,
                                    numUses: $0,
                                   lastUsed: NSDate()) }
        
        let comparator = Merch.comparator(forKey: Merch.SortKey.Uses)
        let sorted = merches.sort(comparator)
        
        XCTAssertEqual(uses.sort((<)), sorted.map { $0.numUses })
    }
}
