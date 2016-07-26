import Foundation

/**
 * A `Merch` is a shopping item: a thing that has been bought at a store.
 *
 * It knows its unit of purchase and internally tracks the number of times
 * it's been used, along with the last date of use.
 */
struct Merch : MarketItem
{
    /** The item name, as entered by and displayed to the user. */
    let name: String
    /** The real-world unit in which the item is purchased, e.g. pints. */
    let unit: Unit
    /** Internal tracking of the number of times this `Merch` is used. */
    private let numUses: UInt
    /** Internal tracking of the last date this `Merch` was used. */
    private let lastUsed: NSDate
    
    init(name: String, unit: Unit? = nil)
    {
        self.name = name
        self.unit = unit ?? .Each
        self.numUses = 0
        self.lastUsed = NSDate()
    }
}

/** Mutation */
extension Merch
{
    func purchasing() -> Merch
    {
        let uses = self.numUses + 1
        return Merch(copy: self, uses: uses, date: NSDate())
    }
    
    func changingUnit(to unit: Unit?) -> Merch
    {
        return Merch(copy: self, unit: unit)
    }
    
    func changingName(to name: String) -> Merch
    {
        return Merch(copy: self, name: name)
    }
    
    private init(copy original: Merch,  
                 name: String?=nil,
                 unit: Unit?=nil,
                 uses: UInt?=nil,
                 date: NSDate?=nil)
    {
        self.name = name ?? original.name
        self.unit = unit ?? original.unit
        self.numUses = uses ?? original.numUses
        self.lastUsed = date ?? original.lastUsed
    }
}

/** Equatability */
func ==(lhs: Merch, rhs: Merch) -> Bool
{
    return lhs.name == rhs.name
}
/** Comparability for sorting. */
func <(lhs: Merch, rhs: Merch) -> Bool
{
    return lhs.name < rhs.name
}
/** Sortability/sorting comparators */
extension Merch
{
    enum SortKey
    {
        /** Sort by the items' names */
        case Name
        /** Sort by the last use date */
        case Date 
        /** Sort by the number of times purchased */
        case Uses
    }
    
    static func comparator(forKey key: SortKey) -> (Merch, Merch) -> Bool
    {
        switch key
        {
            case .Name:
                return (<)
            case .Date:
                return dateComparator
            case .Uses:
                return usesComparator
        }
    }
}

/** Hashability */
extension Merch : Hashable
{
    var hashValue: Int { return self.name.hashValue }
}

/** Compare `Merch`s by date, or name if the dates are equal. */
private func dateComparator(lhs: Merch, rhs: Merch) -> Bool
{
    let (leftDate, rightDate) = (lhs.lastUsed, rhs.lastUsed)
    // For equal dates, resort to default comparison
    guard leftDate != rightDate else {
        return lhs < rhs
    }
    
    return leftDate < rightDate
}

/** Compare `Merch`s by number of uses, or name if the counts are equal. */
private func usesComparator(lhs: Merch, rhs: Merch) -> Bool
{
    let (leftUses, rightUses) = (lhs.numUses, rhs.numUses)
    guard leftUses != rightUses else {
        return lhs < rhs
    }
    return leftUses < rightUses
}
