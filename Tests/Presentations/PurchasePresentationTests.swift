import XCTest
@testable import LoafBottleStickKit

class PurchasePresentationTests : XCTestCase
{
    let purchase = Purchase(merch: Merch.dummy, quantity: 1)
    var presentation: PurchasePresentation!
    
    override func setUp()
    {
        self.presentation = PurchasePresentation(purchase: self.purchase)
    }
    
    //MARK: - Field values
    func testPresentsAllFields()
    {
        XCTAssertEqual(self.purchase.name, self.presentation.name)
        XCTAssertEqual(String(self.purchase.unit), 
                       self.presentation.unitDescription)
        XCTAssertEqual(self.purchase.note, self.presentation.note)
        XCTAssertEqual(String(self.purchase.quantity), 
                       self.presentation.quantityDescription)
        XCTAssertEqual(self.purchase.isCheckedOff,
                       self.presentation.isCheckedOff)
    }
    
    func testProvidesPurchaseOnDeletionNotice()
    {
        self.presentation.willDelete { deletingPurchase in
            XCTAssertEqual(self.purchase, deletingPurchase)
        }
    }
    
    // Description of unit should changed based on quantity
    func testZeroUnitDescribedAsNil()
    {
        let purchase = Purchase(merch: Merch.dummy, quantity: 0)
        
        let presentation = PurchasePresentation(purchase: purchase)
        
        XCTAssertNil(presentation.unitDescription)
    }
    
    func testPluralUnitDescription()
    {
        let purchase = Purchase(merch: Merch.dummy, quantity: 3)
        
        let presentation = PurchasePresentation(purchase: purchase)
        
        XCTAssertEqual(purchase.unit.pluralName(), 
                       presentation.unitDescription)
    }
    
    func testZeroQuantityDescribedAsNil()
    {
        let purchase = Purchase(merch: Merch.dummy, quantity: 0)
        
        let presentation = PurchasePresentation(purchase: purchase)
        
        XCTAssertNil(presentation.quantityDescription)
    }  
    
    //MARK: - Mutation
    func testChangesName()
    {
        let newName = Merch.offListDummy.name
        
        self.presentation.name = newName
        
        XCTAssertEqual(newName, self.presentation.name)
    }
    
   func testChangesUnit()
   {
       let newUnit = Merch.offListDummy.unit

       self.presentation.setUnit(newUnit)

       XCTAssertEqual(String(newUnit), self.presentation.unitDescription)
   }
   
   func testChangesNote()
   {
       let newNote = "Get the organic kind"
       
       self.presentation.note = newNote
       
       XCTAssertEqual(newNote, self.presentation.note)
   }
   
   func testChangesQuantity()
   {
       let newQuantity: UInt = 17
       
       self.presentation.setQuantity(newQuantity)
       
       XCTAssertEqual(String(newQuantity), 
                      self.presentation.quantityDescription)
   }
   
   func testChecksAndUnchecks()
   {
       self.presentation.toggleChecked()
       XCTAssertTrue(self.presentation.isCheckedOff)
       self.presentation.toggleChecked()
       XCTAssertFalse(self.presentation.isCheckedOff)
   }
   
   //MARK: - View notifications
   func testNotifiesViewOnChangingName()
   {
       var sentDidUpdate = false
       self.presentation.didUpdate = { sentDidUpdate = true }
       
       self.presentation.name = ""
       
       XCTAssertTrue(sentDidUpdate)
   }
   
   func testNotifiesViewOnChangingUnit()
   {
       var sentDidUpdate = false
       self.presentation.didUpdate = { sentDidUpdate = true }
       
       self.presentation.setUnit(.Loaf)
       
       XCTAssertTrue(sentDidUpdate)
   }
   
   func testNotifiesViewOnChangingNote()
   {
       var sentDidUpdate = false
       self.presentation.didUpdate = { sentDidUpdate = true }
       
       self.presentation.note = "Get the organic kind"
       
       XCTAssertTrue(sentDidUpdate)
   }
   
   func testNotifiesViewOnChangingQuantity()
   {
       var sentDidUpdate = false
       self.presentation.didUpdate = { sentDidUpdate = true }
       
       self.presentation.setQuantity(17)
       
       XCTAssertTrue(sentDidUpdate)
   }
   
   func testNotifiesViewOnTogglingChecked()
   {
       var sentDidUpdate = false
       self.presentation.didUpdate = { sentDidUpdate = true }
       
       self.presentation.toggleChecked()
       
       XCTAssertTrue(sentDidUpdate)
   }
   
   //MARK: - Parent notifications: sent and passing expected values
   func testNotifiesParentOnChangingName()
   {
       let newName = Merch.offListDummy.name
       var sentMerchDidChange = false
       var oldMerch, newMerch: Merch?
       self.presentation.merchDidChange = { 
           (oldVal, newVal) in 
               sentMerchDidChange = true
               (oldMerch, newMerch) = (oldVal, newVal)
       }
       
       self.presentation.name = newName
       
       XCTAssertTrue(sentMerchDidChange)
       stopOnFailure { XCTAssertNotNil(oldMerch) }
       XCTAssertEqual(self.purchase.merch, oldMerch!)
       stopOnFailure { XCTAssertNotNil(newMerch) }
       XCTAssertEqual(newName, newMerch!.name)
   }
   
   func testNotifiesParentOnChangingUnit()
   {
       let newUnit = Merch.offListDummy.unit
       var sentMerchDidChange = false
       var oldMerch, newMerch: Merch?
       self.presentation.merchDidChange = { 
           (oldVal, newVal) in 
               sentMerchDidChange = true
               (oldMerch, newMerch) = (oldVal, newVal)
       }
       
       self.presentation.setUnit(newUnit)
       
       XCTAssertTrue(sentMerchDidChange)
       stopOnFailure { XCTAssertNotNil(oldMerch) }
       XCTAssertEqual(self.purchase.merch, oldMerch!)
       stopOnFailure { XCTAssertNotNil(newMerch) }
       XCTAssertEqual(newUnit, newMerch!.unit)
   }
   
   func testNotifiesParentOnChangingQuantity()
   {
       let newQuantity: UInt = 17
       var sentValueDidChange = false
       var oldPurchase, newPurchase: Purchase?
       self.presentation.valueDidChange = { 
           (oldVal, newVal) in 
               sentValueDidChange = true
               (oldPurchase, newPurchase) = (oldVal, newVal)
       }
       
       self.presentation.setQuantity(newQuantity)
       
       XCTAssertTrue(sentValueDidChange)
       stopOnFailure { XCTAssertNotNil(oldPurchase) }
       XCTAssertEqual(self.purchase, oldPurchase)
       stopOnFailure { XCTAssertNotNil(newPurchase) }
       XCTAssertEqual(newQuantity, newPurchase!.quantity)
   }
   
   func testNotifiesParentOnChangingNote()
   {
       let newNote = "Get the organic kind"
       var sentValueDidChange = false
       var oldPurchase, newPurchase: Purchase?
       self.presentation.valueDidChange = { 
           (oldVal, newVal) in 
               sentValueDidChange = true
               (oldPurchase, newPurchase) = (oldVal, newVal)
       }
       
       self.presentation.note = newNote
       
       XCTAssertTrue(sentValueDidChange)
       stopOnFailure { XCTAssertNotNil(oldPurchase) }
       XCTAssertEqual(self.purchase, oldPurchase)
       stopOnFailure { XCTAssertNotNil(newPurchase) }
       XCTAssertEqual(newNote, newPurchase!.note)
   }
   
   func testNotifiesParentOnTogglingChecked()
   {
       var sentDidToggle = false
       var sentValueDidChange = false
       var checkedPurchase, oldPurchase, newPurchase: Purchase?
       self.presentation.didToggleChecked = {
           purchase in
               sentDidToggle = true
               checkedPurchase = purchase
       }
       self.presentation.valueDidChange = { 
           (oldVal, newVal) in 
               sentValueDidChange = true
               (oldPurchase, newPurchase) = (oldVal, newVal)
       }
       
       self.presentation.toggleChecked()
       
       XCTAssertTrue(sentDidToggle)
       XCTAssertTrue(sentValueDidChange)
       stopOnFailure { XCTAssertNotNil(checkedPurchase) }
       XCTAssertTrue(checkedPurchase!.isCheckedOff)
       stopOnFailure { XCTAssertNotNil(oldPurchase) }
       XCTAssertEqual(self.purchase, oldPurchase)
       stopOnFailure { XCTAssertNotNil(newPurchase) }
       XCTAssertEqual(checkedPurchase, newPurchase)
   }
}
