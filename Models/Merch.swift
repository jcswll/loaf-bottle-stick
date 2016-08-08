import Foundation

/**
 * A `Merch` is a shopping item: a thing that has been bought at a store.
 *
 * It knows its unit of purchase and internally tracks the number of times it's
 * been used, along with the last date of use.
 */
struct Merch : MarketItem
{
    /** The item name, as entered by and displayed to the user. */
    let name: String
    /** The real-world unit in which the item is purchased, e.g. pints. */
    let unit: Unit
    /** Internal tracking of the number of times this `Merch` is used. */
    let numUses: UInt
    /** Internal tracking of the last date this `Merch` was used. */
    let lastUsed: NSDate
    
    
    init(name: String, unit: Unit, numUses: UInt, lastUsed: NSDate)
    {
        self.name = name
        self.unit = unit
        self.numUses = numUses
        self.lastUsed = lastUsed
    }
    
    /** Creation from provided data. */
    init(data: MerchData)
    {
        self.name = data.name
        self.unit = data.unit
        self.numUses = data.numUses
        self.lastUsed = data.lastUsed
    }
    
    var searchKey: String { return self.name }
    
    
    //MARK: - Sortability
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
                return Merch.dateComparator
            case .Uses:
                return Merch.usesComparator
        }
    }
    
    /** Compare `Merch`s by date, or name if the dates are equal. */
    private static func dateComparator(lhs: Merch, rhs: Merch) -> Bool
    {
        let (leftDate, rightDate) = (lhs.lastUsed, rhs.lastUsed)
        // For equal dates, resort to default comparison
        guard leftDate != rightDate else {
            return lhs < rhs
        }
    
        return leftDate < rightDate
    }

    /** Compare `Merch`s by number of uses, or name if the counts are equal. */
    private static func usesComparator(lhs: Merch, rhs: Merch) -> Bool
    {
        let (leftUses, rightUses) = (lhs.numUses, rhs.numUses)
        guard leftUses != rightUses else {
            return lhs < rhs
        }
        return leftUses < rightUses
    }
    
    var hashValue: Int { return self.name.hashValue }
    
    
    // MARK: - Mutation
    /** Update the internal usage tracking info. */
    func purchasing() -> Merch 
    {
        let uses = self.numUses + 1
        return Merch(copy: self, uses: uses, date: NSDate())
    }
    
    func changingName(to name: String) -> Merch
    {
        return Merch(copy: self, name: name)
    }
    
    func changingUnit(to unit: Unit) -> Merch 
    {
        return Merch(copy: self, unit: unit)
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

//MARK: - Protocol conformance
/* Equatability */
func ==(lhs: Merch, rhs: Merch) -> Bool
{
    return lhs.name == rhs.name
}

/* Comparability/sorting */
func <(lhs: Merch, rhs: Merch) -> Bool
{
    return lhs.name < rhs.name
}
