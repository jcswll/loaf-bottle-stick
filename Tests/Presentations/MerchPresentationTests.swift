import XCTest
@testable import LoafBottleStickKit

class MerchPresentationTests : XCTestCase
{
    let merch: Merch = Merch.dummy
    var presentation: MerchPresentation!

    override func setUp()
    {
        self.presentation = MerchPresentation(merch: self.merch)
    }

    //MARK: - Exposed values
    func testPresentsAllFields()
    {
        XCTAssertEqual(merch.name, self.presentation.name)
        XCTAssertEqual(String(merch.unit), self.presentation.unitName)
    }

    func testProvidesMerchOnDeletionNotice()
    {
        self.presentation.willDelete { deletingMerch in
            XCTAssertEqual(self.merch, deletingMerch)
        }
    }

    //MARK: Mutation
    func testChangesName()
    {
        let newName = Merch.offListDummy.name
        self.presentation.name = newName

        XCTAssertEqual(newName, self.presentation.name)
    }

    func testChangesUnit()
    {
        let newUnit = Merch.offListDummy.unit
        presentation.setUnit(newUnit)

        XCTAssertEqual(String(newUnit), self.presentation.unitName)
    }

    func testDoesPurchase()
    {
        self.presentation.purchase()

        XCTAssertEqual(self.merch.numUses + 1, self.presentation.numUses)
        let lastUsed = self.presentation.lastUsed
        XCTAssertEqualWithAccuracy(0, lastUsed.timeIntervalSinceNow,
                                   accuracy: 2)
    }

    //MARK: - View notifications
    func testNotifiesViewOnNameChange()
    {
        let newName = Merch.offListDummy.name
        var sentDidUpdate = false
        self.presentation.didUpdate = { sentDidUpdate = true }

        self.presentation.name = newName

        XCTAssertTrue(sentDidUpdate)
    }

    func testNotifiesViewOnUnitChange()
    {
        let newUnit = Merch.offListDummy.unit
        var sentDidUpdate = false
        self.presentation.didUpdate = { sentDidUpdate = true }

        presentation.setUnit(newUnit)

        XCTAssertTrue(sentDidUpdate)
    }

    func testNotifiesViewOnPurchase()
    {
        var sentDidUpdate = false
        self.presentation.didUpdate = { sentDidUpdate = true }

        self.presentation.purchase()

        XCTAssertTrue(sentDidUpdate)
    }

    //MARK: - Parent notifications: sent and passing expected values
    func testNotifiesParentOnNameChange()
    {
        let newName = Merch.offListDummy.name
        var sentValueDidChange = false
        var old, new: Merch?
        self.presentation.valueDidChange = { (oldVal, newVal) in
            
            (old, new) = (oldVal, newVal)
            sentValueDidChange = true
        }

        presentation.name = newName

        XCTAssertTrue(sentValueDidChange)
        //swiftlint:disable force_unwrapping
        stopOnFailure { XCTAssertNotNil(old) }
        XCTAssertEqual(self.merch, old!)
        stopOnFailure { XCTAssertNotNil(new) }
        XCTAssertEqual(newName, new!.name)
        //swiftlint:enable force_unwrapping
    }

    func testNotifiesParentOnUnitChange()
    {
        let newUnit = Merch.offListDummy.unit
        var sentValueDidChange = false
        var old, new: Merch?
        self.presentation.valueDidChange = { (oldVal, newVal) in
            
            (old, new) = (oldVal, newVal)
            sentValueDidChange = true
        }

        presentation.setUnit(newUnit)

        XCTAssertTrue(sentValueDidChange)
        //swiftlint:disable force_unwrapping
        stopOnFailure { XCTAssertNotNil(old) }
        XCTAssertEqual(self.merch, old!)
        stopOnFailure { XCTAssertNotNil(new) }
        XCTAssertEqual(newUnit, new!.unit)
        //swiftlint:enable force_unwrapping
    }

    func testNotifiesParentOnPurchase()
    {
        var sentDidPurchase = false
        var purchasedMerch: Merch?
        self.presentation.didPurchase = { (merch, _) in
            
            sentDidPurchase = true
            purchasedMerch = merch
        }

        self.presentation.purchase()

        XCTAssertTrue(sentDidPurchase)
        stopOnFailure { XCTAssertNotNil(purchasedMerch) }
        //swiftlint:disable force_unwrapping
        XCTAssertEqual(self.merch.name, purchasedMerch!.name)
        //swiftlint:enable force_unwrapping
    }
}
