@testable import LoafBottleStickKit

extension Purchase
{
    init(merch: Merch, note: String?, quantity: UInt?, checkedOff: Bool)
    {
        self.merch = merch
        self.note = note
        self.quantity = quantity
        self.isCheckedOff = checkedOff
    }
}