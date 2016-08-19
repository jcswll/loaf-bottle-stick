/**
 * Presents a `Merch`'s fields and associated behavior to a view.
 *
 * When changes are made, the view and other observers are notified via
 * callback closures.
 */
class MerchPresentation
{
    /** The presented `Merch`. */
    private var merch: Merch
    /** "Undo" stack */
    private var oldMerch: [Merch] = []

    init(merch: Merch)
    {
        self.merch = merch
    }

    /** Allow sorting lists of presentations without exposing `merch`. */
    func compare(to other: MerchPresentation, byKey key: Merch.SortKey)
        -> Bool
    {
        let comparator = Merch.comparator(forKey: key)
        return comparator(self.merch, other.merch)
    }

    //MARK: - `Merch` fields
    /** The name of the enclosed `Merch` */
    var name: String
    {
        get { return self.merch.name }
        set(name)
        {
            self.saveValue()
            self.merch = self.merch.changingName(to: name)
            self.announceChanges()
        }
    }

    /** The string to display for the unit. */
    var unitName: String { return self.merch.unit.rawValue }

    /** Change unit by actual enum value rather than a string. */
    func setUnit(unit: Unit)
    {
        self.saveValue()
        self.merch = self.merch.changingUnit(to: unit)
        self.announceChanges()
    }

    // MARK: - Data events
    /** Tell view that new values should be read. */
    var didUpdate: (() -> Void)?
    /** Pass value changes out to an observer. */
    var valueDidChange: ((old: Merch, new: Merch) -> Void)?
    /** Pass purchased merch out to an observer. */
    var didPurchase: ((Merch, UInt) -> Void)?

    /** Provide access to private `merch` in a passed-in closure. */
    func willDelete(@noescape deletion: ((Merch) -> Void))
    {
        deletion(self.merch)
    }

    // MARK: - Input
    /**
     * Update the enclosed `Merch` by `purchasing()` it, and notify observers.
     */
    func purchase()
    {
        self.saveValue()
        self.merch = self.merch.purchasing()
        self.announceChanges(fromPurchasing: true)
    }

    // MARK: - Internals
    /** Notify view and value observers of value changes. */
    private func announceChanges(fromPurchasing fromPurchasing: Bool = false)
    {
        self.didUpdate?()

        self.valueDidChange?(old: self.lastValue, new: self.merch)

        if fromPurchasing {
            //FIXME: Get actual quantity
            self.didPurchase?(self.merch, 0)
        }
    }

    /** Push value onto the undo stack */
    private func saveValue()
    {
        self.oldMerch.append(self.merch)
    }
    /** Peek value from the undo stack */
    // swiftlint:disable:next force_unwrapping
    private var lastValue: Merch { return self.oldMerch.last! }
}

// Hacks to allow easy checking of updated values that are otherwise hidden.
#if TESTING
extension MerchPresentation
{
    var numUses: UInt { return self.merch.numUses }
    var lastUsed: NSDate { return self.merch.lastUsed }
}
#endif
