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
    func testCheckingAndUnchecking()
    {
        let purchase = Purchase.dummy

        let checked = purchase.checkingOff()
        let unchecked = purchase.unchecking()

        XCTAssertTrue(checked.isCheckedOff)
        XCTAssertFalse(unchecked.isCheckedOff)
    }

    func testCheckingAndUncheckingPreservesOtherFields()
    {
        let merch = Merch.dummy
        let note = "Get the organic kind"
        let quantity: UInt = 3
        let checkedOff = true
        // All fields explicitly set for this test
        let purchase = Purchase(merch: merch,
                                 note: note,
                             quantity: quantity,
                           checkedOff: checkedOff)

        let checked = purchase.checkingOff()
        let unchecked = purchase.unchecking()

        XCTAssertEqual(purchase.name, checked.name)
        XCTAssertEqual(purchase.name, unchecked.name)
        XCTAssertEqual(purchase.unit, checked.unit)
        XCTAssertEqual(purchase.unit, unchecked.unit)
        XCTAssertEqual(purchase.quantity, checked.quantity)
        XCTAssertEqual(purchase.quantity, unchecked.quantity)
        XCTAssertEqual(purchase.note, checked.note)
        XCTAssertEqual(purchase.note, unchecked.note)
    }

    func testChangingNote()
    {
        let purchase = Purchase.dummy
        let newNote = "Get the organic kind"

        let changed = purchase.changingNote(to: newNote)

        XCTAssertEqual(newNote, changed.note)
    }

    func testChangingNotePreservesOtherFields()
    {
        let merch = Merch.dummy
        let quantity: UInt = 3
        let note = "Make sure it's fresh"
        let checkedOff = true
        let newNote = "Get the organic kind"
        // All fields explicitly set for this test
        let purchase = Purchase(merch: merch,
                                 note: note,
                             quantity: quantity,
                           checkedOff: checkedOff)

        let changed = purchase.changingNote(to: newNote)

        XCTAssertEqual(purchase.name, changed.name)
        XCTAssertEqual(purchase.unit, changed.unit)
        XCTAssertEqual(purchase.quantity, changed.quantity)
        XCTAssertEqual(purchase.isCheckedOff, changed.isCheckedOff)
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

    func testChangingQuantityPreservesOtherFields()
    {
        let merch = Merch.dummy
        let quantity: UInt = 3
        let note = "Get the organic kind"
        let checkedOff = true
        let newQuantity: UInt = 21
        // All fields explicitly set for this test
        let purchase = Purchase(merch: merch,
                                 note: note,
                             quantity: quantity,
                           checkedOff: checkedOff)

        let changed = purchase.changingQuantity(to: newQuantity)

        XCTAssertEqual(purchase.name, changed.name)
        XCTAssertEqual(purchase.unit, changed.unit)
        XCTAssertEqual(purchase.note, changed.note)
        XCTAssertEqual(purchase.isCheckedOff, changed.isCheckedOff)
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
        let note = "Get the organic kind"
        let checkedOff = true
        let newName = "Milk"
        // All fields explicitly set for this test
        let purchase = Purchase(merch: merch,
                                 note: note,
                             quantity: quantity,
                           checkedOff: checkedOff)

        let changed = purchase.changingName(to: newName)

        XCTAssertEqual(purchase.unit, changed.unit)
        XCTAssertEqual(purchase.quantity, changed.quantity)
        XCTAssertEqual(purchase.note, changed.note)
        XCTAssertEqual(purchase.isCheckedOff, changed.isCheckedOff)
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
        let note = "Get the organic kind"
        let checkedOff = true
        // All fields explicitly set for this test
        let purchase = Purchase(merch: merch,
                                 note: note,
                             quantity: quantity,
                           checkedOff: checkedOff)

        let newUnit = Unit.Box
        let changed = purchase.changingUnit(to: newUnit)

        XCTAssertEqual(purchase.name, changed.name)
        XCTAssertEqual(purchase.quantity, changed.quantity)
        XCTAssertEqual(purchase.note, changed.note)
        XCTAssertEqual(purchase.isCheckedOff, changed.isCheckedOff)
    }

    //MARK: Sorting
    func testCanSortByName()
    {
        let names = Merch.dummyNames
        let merches = Merch.dummies
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
