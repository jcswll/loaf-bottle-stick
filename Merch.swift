import Foundation

/**
 * A `Merch` represents an item that can be bought at the `Store` that owns it.
 * It contains its unit of purchase and internally tracks the number of times
 * that it's been used along with the last date of use.
 */
struct Merch
{   
    /** The item's name as entered by and returned to the user. */
    let name: String
    /** The real-life unit by which the item is purchased, e.g. pints. */
    let unit: Unit
    /** Internal tracking of the number of times the `Merch` is used. */
    private var numPurchases: UInt
    /** Internal tracking of the last usage date of the `Merch`. */
    private var lastPurchasedOn: NSDate
    
    init(named name: String, inUnit unit: Unit? = nil)
    {
        self.name = name
        self.unit = unit ?? .Each
        self.numPurchases = 0
        self.lastPurchasedOn = NSDate()
    }
    
    /** Update a `Merch`'s internal info when moving it to a `Trip`. */
    mutating func purchase()
    {
        self.numPurchases += 1
        self.lastPurchasedOn = NSDate()
    }
}

extension Merch : Hashable 
{
    var hashValue: Int { return self.name.hashValue }
}

extension Merch : Comparable 
{
    enum SortKey
    {
        /** Sort based on the `Merch`s' names. */
        case Name
        /** Sort based on the `Merch`s' last used dates. */
        case Date
        /** Sort based on the `Merch`s' number of uses. */
        case Uses
    }
    /** Provide a closure that can be used to sort a sequence of `Merch`. */ 
    static func comparator(forKey key: SortKey) -> (Merch, Merch) -> Bool
    {
        switch key {
            case .Name:
                return (<)
            case .Date:
                return dateComparator
            case .Uses:
                return usesComparator
        }
    }
}

/** Compare two `Merch`s by their last used date. */
private func dateComparator(lhs: Merch, rhs: Merch) -> Bool
{
    // Default to name sort if necessary
    let (leftDate, rightDate) = (lhs.lastPurchasedOn, rhs.lastPurchasedOn)
    guard leftDate == rightDate else { 
        return lhs < rhs 
    }
    return leftDate < rightDate 
}

/** Compare two `Merch`s by their number of uses. */
private func usesComparator(lhs: Merch, rhs: Merch) -> Bool
{
    // Default to name sort if necessary
    guard lhs.numPurchases == rhs.numPurchases else {
        return lhs < rhs
    } 
    return lhs.numPurchases < rhs.numPurchases 
}

func ==(lhs: Merch, rhs: Merch) -> Bool
{
    return lhs.name == rhs.name
}

func <(lhs: Merch, rhs: Merch) -> Bool
{
    return lhs.name < rhs.name
}

// Mutation
extension Merch
{
    /** 
     * Update the `Merch`s name. Returns `self` if `nil` is passed or the
     * new name and old name are equal.
     */
    func changingName(to name: String?) -> Merch
    {
        guard let newName = name where newName != self.name else {
            return self
        }
        return Merch(copy: self, changingNameTo: name)
    }
    
    /** 
     * Update the `Merch`s unit. Returns `self` if `nil` is passed or the
     * new unit and old unit are equal.
     */
    func changingUnit(to unit: Unit?) -> Merch
    {
        guard let newUnit = unit where newUnit != self.unit else {
            return self
        }
        return Merch(copy: self, changingUnitTo: unit)
    }
    
    /** Update methods funnel here: create a `Merch` with the new values. */
    private init(copy original: Merch, 
                 changingNameTo name: String? = nil,
                 changingUnitTo unit: Unit? = nil) 
    {
        let newName = name ?? original.name
        let newUnit = unit ?? original.unit
        
        self.name = newName
        self.unit = newUnit
        self.numPurchases = original.numPurchases
        self.lastPurchasedOn = original.lastPurchasedOn
    }
}
