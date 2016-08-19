/**
 * A `Purchase` represents an entry on a shopping list.
 */
struct Purchase : MarketItem
{
    /**
     * The represented `Merch`; this provides access to name and unit, and
     * facilitates sort.
     */
    let merch: Merch
    /** Purchase's name, from its merch. */
    var name: String { return self.merch.name }
    /** Purchase's unit, from its merch. */
    var unit: Unit { return self.merch.unit }
    /** An optional note on the list item, as entered by the user. */
    let note: String?
    /** Amount to be purchased, in the unit defined by the `Merch`. */
    let quantity: UInt
    /** The state of the item w/r/t the user's "shopping basket": */
    let isCheckedOff: Bool

    /** Creation for a given `Merch`, with quantity. */
    init(merch: Merch, quantity: UInt=0)
    {
        self.merch = merch
        self.quantity = quantity
        self.note = nil
        self.isCheckedOff = false
    }

    var searchKey: Merch { return self.merch }

    //MARK: - Sortability
    /* Purchases simply sort by their contained Merch. */
    typealias SortKey = Merch.SortKey

    static func comparator(forKey key: SortKey)
               -> ((Purchase, Purchase) -> Bool)
    {
        return { (lhs: Purchase, rhs: Purchase) -> Bool in
            let comparator = Merch.comparator(forKey: key)
            return comparator(lhs.merch, rhs.merch)
        }
    }

    /** Mutation: checking off, editing name, unit, note, or quantity */
    func changingName(to name: String) -> Purchase
    {
        let merch = self.merch.changingName(to: name)
        return Purchase(copy: self, merch: merch)
    }

    func changingUnit(to unit: Unit) -> Purchase
    {
        let merch = self.merch.changingUnit(to: unit)
        return Purchase(copy: self, merch: merch)
    }

    func changingNote(to note: String?) -> Purchase
    {
        return Purchase(copy: self, quantity: self.quantity, note: note)
    }

    func changingQuantity(to quantity: UInt) -> Purchase
    {
        return Purchase(copy: self, quantity: quantity, note: self.note)
    }

    func checkingOff() -> Purchase
    {
        return Purchase(copy: self, checkingOff: true)
    }

    func unchecking() -> Purchase
    {
        return Purchase(copy: self, checkingOff: false)
    }

    private init(copy original: Purchase, checkingOff checked: Bool)
    {
        self.merch = original.merch
        self.note = original.note
        self.quantity = original.quantity
        self.isCheckedOff = checked
    }

    private init(copy original: Purchase,
          quantity newQuantity: UInt,
                  note newNote: String?)
    {
        self.merch = original.merch
        self.note = newNote
        self.quantity = newQuantity
        self.isCheckedOff = original.isCheckedOff
    }

    private init(copy original: Purchase,
                merch newMerch: Merch)
    {
        self.merch = newMerch
        self.note = original.note
        self.quantity = original.quantity
        self.isCheckedOff = original.isCheckedOff
    }
}

/* Equatability */
func ==(lhs: Purchase, rhs: Purchase) -> Bool
{
    return lhs.merch == rhs.merch
}

/* Comparability/sorting */
func <(lhs: Purchase, rhs: Purchase) -> Bool
{
    return lhs.merch < rhs.merch
}
