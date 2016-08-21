@testable import LoafBottleStickKit

extension Purchase
{
    /** A test `Purchase`, created with `Merch.dummy` and no quantity. */
    static var dummy: Purchase { return Purchase(merch: Merch.dummy) }

    /** Test `Purchase`s created with `Merch.dummies` and no quantities. */
    static var dummies: [Purchase] {
        return Merch.dummies.map { Purchase(merch: $0) }
    }

    /** A test `Purchase` not included in the `dummies` list. */
    static var offListDummy: Purchase {
        return Purchase(merch: Merch.offListDummy)
    }

    /** Easy creation for testing */
    init(merch: Merch, note: String?, quantity: UInt, checkedOff: Bool)
    {
        self.merch = merch
        self.note = note
        self.quantity = quantity
        self.isCheckedOff = checkedOff
    }
}
