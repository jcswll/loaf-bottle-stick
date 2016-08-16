@testable import LoafBottleStickKit

extension Purchase
{
    /** A test `Purchase`, created with `Merch.dummy` and no quantity. */
    static var dummy: Purchase { return Purchase(merch: Merch.dummy) }
    
    static var dummies: [Purchase] {
        return Merch.dummies.map { Purchase(merch: $0) }
    }
    
    static var offListDummy: Purchase { 
        return Purchase(merch: Merch.offListDummy) 
    }
    
    init(merch: Merch, note: String?, quantity: UInt, checkedOff: Bool)
    {
        self.merch = merch
        self.note = note
        self.quantity = quantity
        self.isCheckedOff = checkedOff
    }
}