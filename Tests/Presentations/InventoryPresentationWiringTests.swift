import XCTest
@testable import LoafBottleStickKit

class InventoryPresentationWiringTests : XCTestCase
{
    let inventory: MarketList<Merch> = MarketList(items: Set(Merch.dummies))
    var presentation: InventoryPresentation!

    override func setUp()
    {
        self.presentation = InventoryPresentation(inventory: self.inventory)
        self.presentation.sortKey = .Name
    }

    func testItemModified()
    {
        let merchPresentation = self.presentation.subPresentations[0]
        let oldName = merchPresentation.name
        let newName = Merch.offListDummy.name

        merchPresentation.name = newName
        
        let subPresentations = self.presentation.subPresentations
        XCTAssertTrue(subPresentations.contains { $0.name == newName })
        XCTAssertFalse(subPresentations.contains { $0.name == oldName })
    }
    
    func testNotifiesViewWhenItemModified()
    {
        let merchPresentation = self.presentation.subPresentations[0]
        var sentDidUpdate = false
        self.presentation.didUpdate = { sentDidUpdate = true }
        
        merchPresentation.name = Merch.offListDummy.name
        
        XCTAssertTrue(sentDidUpdate)
    }
    
    func testNotifiesParentWhenItemModified()
    {
        let merchPresentation = self.presentation.subPresentations[0]
        var sentDidChange = false
        self.presentation.merchDidChange = {
            (_, _) in
                sentDidChange = true
        }
        
        merchPresentation.name = Merch.offListDummy.name
        
        XCTAssertTrue(sentDidChange)        
    }
    
    func testUpdatesOrderWhenItemModified()
    {
        let merchPresentation = self.presentation.subPresentations[0]
        let oldName = merchPresentation.name
        let newName = Merch.offListDummy.name
        let sortedNames = Merch.dummyNames.map { 
                                              $0 == oldName ? newName : $0 
                                          }.sort((<))
        
        merchPresentation.name = newName
        
        XCTAssertEqual(sortedNames,
                       self.presentation.subPresentations.map {
                               $0.name
                       })
    }
    
    func testNotifiesParentWhenPurchasing()
    {
        let merchPresentation = self.presentation.subPresentations[0]
        var sentDidPurchase = false
        self.presentation.makePurchase = { (_, _) in sentDidPurchase = true }
        
        merchPresentation.purchase()
        
        XCTAssertTrue(sentDidPurchase)
    }
    
    func testNotifiesViewWhenPurchasing()
    {
        let merchPresentation = self.presentation.subPresentations[0]
        var sentDidUpdate = false
        self.presentation.makePurchase = { (_, _) in sentDidUpdate = true }
        
        merchPresentation.purchase()
        
        XCTAssertTrue(sentDidUpdate) 
    }
}
