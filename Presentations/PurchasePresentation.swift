/**
 * Presents a `Purchase`'s fields and associated behavior to a view.
 *
 * When changes are made, the view and other observers are notified via
 * callback closures.
 */
class PurchasePresentation
{
    /** The presented `Purchase` */
    private var purchase: Purchase
    /** Undo stack */
    private var oldPurchases: [Purchase] = []

    init(purchase: Purchase)
    {
        self.purchase = purchase
    }
                          
    /** Allow sorting lists of presentations without exposing `merch`. */
    func compare(to other: PurchasePresentation, byKey key: Purchase.SortKey)
        -> Bool
    {
        let comparator = Purchase.comparator(forKey: key)
        return comparator(self.purchase, other.purchase)
    }

    // MARK: - Fields
    /** The name of the enclosed `Purchase`. */
    var name: String
    {
        get {
            return self.purchase.name
        }
        set(name) {

            self.saveValue()
            self.purchase = self.purchase.changingName(to: name)
            self.announceChanges(toMerch: true)
        }
    }

    /**
     * A string to display for the unit. `nil` if no quantity is set, plural
     * if quantity is greater than one.
     */
    var unitDescription: String?
    {
        let quantity = self.purchase.quantity
        guard quantity > 0 else { return nil }

        let unit = self.purchase.unit
        return quantity == 1 ? String(unit) : unit.pluralName()
    }

    /** Change unit by actual enum value rather than a string. */
    func setUnit(unit: Unit)
    {
        self.saveValue()
        self.purchase = self.purchase.changingUnit(to: unit)
        self.announceChanges(toMerch: true)
    }

    /** The note of the enclosed `Purchase`. */
    var note: String?
    {
        get {
            return self.purchase.note
        }
        set(note) {

            self.saveValue()
            self.purchase = self.purchase.changingNote(to: note)
            self.announceChanges()
        }
    }

    /**
     * A string for the `Purchase`'s quantity. `nil` if no quantity is set.
     */
    var quantityDescription: String?
    {
        let quantity = self.purchase.quantity
        guard quantity > 0 else { return nil }

        return String(quantity)
    }

    /** Change quantity by raw integer value rather than string. */
    func setQuantity(quantity: UInt)
    {
        self.saveValue()
        self.purchase = self.purchase.changingQuantity(to: quantity)
        self.announceChanges()
    }

    /**
     * The state of being checked: whether the user has this item in their
     * shopping basket or not.
     */
    var isCheckedOff: Bool { return self.purchase.isCheckedOff }
    func toggleChecked()
    {
        self.saveValue()
        self.purchase = self.isCheckedOff ? self.purchase.unchecking() :
                                            self.purchase.checkingOff()
        self.announceChanges(fromTogglingChecked: true)
    }

    // MARK: - Events
    /** Notify view to read new values. */
    var didUpdate: (() -> Void)?
    /** Notify parent of changes to enclosed `Merch`. */
    var merchDidChange: ((old: Merch, new: Merch) -> Void)?
    /** Notify parent of other changes. */
    var valueDidChange: ((old: Purchase, new: Purchase) -> Void)?
    /** Notify parent of changes to `isCheckedOff`. */
    var didToggleChecked: ((Purchase) -> Void)?

    /** Provide access to private `purchase` in a passed-in closure. */
    func willDelete(@noescape deletion: ((Purchase) -> Void))
    {
        deletion(self.purchase)
    }

    // MARK: - Internals
    /** Notify view and value observers of value changes. */
    private func announceChanges(fromTogglingChecked toggling: Bool = false,
                                 toMerch: Bool = false)
    {
        self.didUpdate?()

        if toggling {
            self.didToggleChecked?(self.purchase)
        }

        if toMerch {
            self.merchDidChange?(old: self.lastValue.merch,
                                 new: self.purchase.merch)
        }

        self.valueDidChange?(old: self.lastValue, new: self.purchase)
    }

    /** Push value onto the undo stack */
    private func saveValue()
    {
        self.oldPurchases.append(self.purchase)
    }
    /** Peek value from the undo stack */
    // swiftlint:disable:next force_unwrapping
    private var lastValue: Purchase { return self.oldPurchases.last! }
}
