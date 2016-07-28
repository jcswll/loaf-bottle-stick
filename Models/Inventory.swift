/**
 * An `Inventory` manages `Merch` for a `Market`. It represents all the items
 * that have been purchased at that store in the past.
 */
struct Inventory : MarketList
{
    typealias Item = Merch
    /** All `Merch` */
    var items: Set<Merch>

    /** Creation from provided data */
    init(data: InventoryData)
    {
        self.items = data.merchandise
    }
    
    /** Default (empty) creation */
    init()
    {
        self.items = []
    }
    
    /** Add a `Merch` to `items` by name */
    mutating func createMerch(named name: String, inUnit unit: Unit? = nil)
                 -> Merch
    {
        let merch = Merch(name: name, unit: unit)
        self.items.insert(merch)
        return merch
    }
    
    /** Query for items whose names match a string. */
    func merch(forTerm prefix: String) -> [Merch]
    {
        return self.items.filter { $0.name.hasPrefix(prefix) }
    }
}


