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
    var unit: Unit? { return self.merch.unit }
    /** An optional note on the list item, as entered by the user. */
    let note: String?
    /** Optional amount to be purchased, in the unit defined by the `Merch`. */
    let quantity: UInt?
    /** The state of the item w/r/t the user's "shopping basket": */
    let isCheckedOff: Bool
    
    /** Creation for a given `Merch`, with optional quantity. */
    init(merch: Merch, quantity: UInt?)
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
    
    static func comparator(forKey key: SortKey) -> (Purchase, Purchase) -> Bool
    {
        return { (lhs: Purchase, rhs: Purchase) -> Bool in
            let comparator = Merch.comparator(forKey: key)
            return comparator(lhs.merch, rhs.merch)
        }
    }
    
    var hashValue: Int { return self.merch.hashValue }
    
    /** Mutation: checking off, editing note or quantity */
    mutating func checkingOff() -> Purchase
    {
        return Purchase(copy: self, checkingOff: true)
    }

    mutating func unchecking() -> Purchase
    {
        return Purchase(copy: self, checkingOff: false)
    }

    func changingNote(to note: String?) -> Purchase
    {
        return Purchase(copy: self, note: note, quantity: self.quantity)
    }

    func changingQuantity(to quantity: UInt?) -> Purchase
    {
        // Convert 0 quantity into nil
        let quantity = (quantity == 0) ? nil : quantity
        return Purchase(copy: self, note: self.note, quantity: quantity)
    }

    func changingMerch(to merch: Merch) -> Purchase 
    {
        return Purchase(copy: self, merch: merch)
    }

    private init(copy original: Purchase, 
                  note newNote: String?,
          quantity newQuantity: UInt?)
    {
        self.merch = original.merch
        self.note = newNote
        self.quantity = newQuantity
        self.isCheckedOff = original.isCheckedOff
    }
    
    private init(copy original: Purchase, checkingOff checked: Bool)
    {
        self.merch = original.merch
        self.note = original.note
        self.quantity = original.quantity
        self.isCheckedOff = checked
    }

    private init(copy original: Purchase, merch: Merch)
    {
        self.merch = merch
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
