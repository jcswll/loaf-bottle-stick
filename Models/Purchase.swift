/**
 * A `Purchase` represents an entry on a shopping list, consisting of a `Merch`,
 * the state of being checked off or not, and, optionally, quantity and note.
 */
struct Purchase : MarketItem
{
    /** 
     * The represented `Merch`; this provides access to name and unit, and 
     * facilitates sort.
     */
    private let merch: Merch
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
    
    /** Creation from a `Merch` and optional quantity */
    init(ofMerch merch: Merch, inQuantity quantity: UInt?)
    {
        self.merch = merch
        self.note = nil
        self.quantity = quantity
        self.isCheckedOff = false
    }
    
    /** Test whether this `Purchase` represents the given `Merch`. */
    func isOf(merch: Merch) -> Bool 
    {
        return self.merch == merch
    }
}

/** Mutation: checking off, editing note or quantity */
extension Purchase
{
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
        let quantity = (quantity == Optional(0)) ? nil : quantity
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

/** Equatability */
func ==(lhs: Purchase, rhs: Purchase) -> Bool
{
    return lhs.merch == rhs.merch
}
/** Comparability/sorting */
func <(lhs: Purchase, rhs: Purchase) -> Bool
{
    return lhs.merch < rhs.merch
}

/** Purchases simply sort by their contained Merch. */
extension Purchase
{
    typealias SortKey = Merch.SortKey
    
    static func comparator(forKey key: SortKey) -> (Purchase, Purchase) -> Bool
    {
        return { (lhs: Purchase, rhs: Purchase) -> Bool in
            let comparator = Merch.comparator(forKey: key)
            return comparator(lhs.merch, rhs.merch)
        }
    }
}

/** Hashability */
extension Purchase : Hashable
{
    var hashValue: Int { return self.merch.hashValue }
}
