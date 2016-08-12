@testable import LoafBottleStickKit

extension Purchase
{
    /** A test `Purchase`, created with `Merch.dummy` and no quantity. */
    static var dummy: Purchase { return Purchase(merch: Merch.dummy) }
    
    init(merch: Merch, note: String?, quantity: UInt, checkedOff: Bool)
    {
        self.merch = merch
        self.note = note
        self.quantity = quantity
        self.isCheckedOff = checkedOff
    }
}