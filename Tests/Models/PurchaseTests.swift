import XCTest
@testable import LoafBottleStickKit

class PurchaseTests : XCTestCase
{
    //MARK: Basic functionality
    func testInitializes()
    {
       let merch = Merch.dummy
       let note: String? = nil    // Default empty note
       let quantity: UInt = 3

       let purchase = Purchase(merch: merch, quantity: quantity)

       XCTAssertEqual(merch.name, purchase.name)
       XCTAssertEqual(merch.unit, purchase.unit)
       XCTAssertEqual(merch, purchase.merch)
       XCTAssertEqual(note, purchase.note)
       XCTAssertEqual(quantity, purchase.quantity)

       // Default quantity
       let purchaseNoQuantity = Purchase(merch: merch)
       XCTAssertEqual(0, purchaseNoQuantity.quantity)
    }
    
    func testSearchesByMerch()
    {
        let merch = Merch.dummy
        
        let purchase = Purchase(merch: merch)
        
        XCTAssertEqual(merch, purchase.searchKey)
    }
    
    //MARK: Mutation
    func testCheckingOff()
    {
        let merch = Merch.dummy

        let purchase = Purchase(merch: merch)
        let checked = purchase.checkingOff()
        let unchecked = purchase.unchecking()
        
        XCTAssertTrue(checked.isCheckedOff)
        XCTAssertFalse(unchecked.isCheckedOff)
    }
    
    func testCheckingOffPreservesOtherFields()
    {
        let merch = Merch.dummy
        let note: String? = nil    // Default empty note
        let quantity: UInt = 3

        let purchase = Purchase(merch: merch, quantity: quantity)
        let checked = purchase.checkingOff()
        let unchecked = purchase.unchecking()

        XCTAssertEqual(merch, checked.merch)
        XCTAssertEqual(merch, unchecked.merch)
        XCTAssertEqual(quantity, checked.quantity)
        XCTAssertEqual(quantity, unchecked.quantity)
        XCTAssertEqual(note, checked.note)
        XCTAssertEqual(note, unchecked.note)
    }
    
    func testChangingNote()
    {
        let merch = Merch.dummy
        let quantity: UInt = 3
        let newNote = "Get the organic kind"
        let purchase = Purchase(merch: merch, quantity: quantity)
        
        let changed = purchase.changingNote(to: newNote)
        
        XCTAssertEqual(newNote, changed.note)
    }
    
    func testChangingNotePreservesOtherFields()
    {
        let merch = Merch.dummy
        let quantity: UInt = 3
        let newNote = "Get the organic kind"
        let purchase = Purchase(merch: merch, quantity: quantity)
        
        let changed = purchase.changingNote(to: newNote)
        
        XCTAssertEqual(merch, changed.merch)
        XCTAssertEqual(quantity, changed.quantity)
        XCTAssertFalse(changed.isCheckedOff)
    }
    
    func testChangingQuantity()
    {
        let merch = Merch.dummy
        let quantity: UInt = 3
        let newQuantity: UInt = 21
        let purchase = Purchase(merch: merch, quantity: quantity)
        
        let changed = purchase.changingQuantity(to: newQuantity)
        
        XCTAssertEqual(newQuantity, changed.quantity)
    }
     
    func testChangingName()
    {
        let merch = Merch.dummy
        let quantity: UInt = 3
        let newName = "Milk"
        let purchase = Purchase(merch: merch, quantity: quantity)

        let changed = purchase.changingName(to: newName)

        XCTAssertEqual(newName, changed.name)
    }
    
    func testChangingNamePreservesOtherFields()
    {
        let merch = Merch.dummy
        let quantity: UInt = 3
        let note: String? = nil    // Default empty note
        let newName = "Milk"
        let purchase = Purchase(merch: merch, quantity: quantity)

        let changed = purchase.changingName(to: newName)
        
        XCTAssertEqual(purchase.unit, changed.unit)
        XCTAssertEqual(quantity, changed.quantity)
        XCTAssertEqual(note, changed.note)
        XCTAssertFalse(changed.isCheckedOff)
    }
    
    func testChangingUnit()
    {
        let merch = Merch.dummy
        let quantity: UInt = 3
        let newUnit = Unit.Box
        let purchase = Purchase(merch: merch, quantity: quantity)

        let changed = purchase.changingUnit(to: newUnit)

        XCTAssertEqual(newUnit, changed.unit)
    }
    
    func testChangingUnitPreservesOtherFields()
    {
        let merch = Merch.dummy
        let quantity: UInt = 3
        let note: String? = nil    // Default empty note
        let newUnit = Unit.Box
        let purchase = Purchase(merch: merch, quantity: quantity)

        let changed = purchase.changingUnit(to: newUnit)
        
        XCTAssertEqual(purchase.name, changed.name)
        XCTAssertEqual(quantity, changed.quantity)
        XCTAssertEqual(note, changed.note)
        XCTAssertFalse(changed.isCheckedOff)
    }
    
    //MARK: Sorting
    func testCanSortByName()
    {
        let names = ["Broccoli", "Bananas", "Carrots", "Apples", "Quince"]
        let merches = names.map { Merch(name: $0, unit: nil) }
        let purchases = merches.map { Purchase(merch: $0) }
        
        let comparator = Purchase.comparator(forKey: Purchase.SortKey.Name)
        let sorted = purchases.sort(comparator)
        
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
        let purchases = merches.map { Purchase(merch: $0) }

        let comparator = Purchase.comparator(forKey: Purchase.SortKey.Date)
        let sorted = purchases.sort(comparator)

        XCTAssertEqual(intervals.sort((<)),
                       sorted.map { $0.merch.lastUsed.timeIntervalSince1970 })
    }

    func testCanSortByUses()
    {
        let uses: [UInt] = [4, 5, 6, 1, 3, 2, 7]
        let merches = uses.map { Merch(name: "",
                                       unit: .Each,
                                    numUses: $0,
                                   lastUsed: NSDate()) }
        let purchases = merches.map { Purchase(merch: $0) }

        let comparator = Purchase.comparator(forKey: Purchase.SortKey.Uses)
        let sorted = purchases.sort(comparator)

        XCTAssertEqual(uses.sort((<)), sorted.map { $0.merch.numUses })
    }
}
