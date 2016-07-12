/**
 * `Inventory` manages `Merch` for a `Store`.
 * Vends `Merch` by name, as a sorted list, or matching a name prefix.
 * Adds `Merch` by name to the inventory.
 */

struct Inventory
{
    private var merchandise = Set<Merch>
    
    /** All `Merch`, sorted by key. */
    func merchandise(sortedBy key: MerchSortKey) -> [Merch]
    {
        let comparator = Merch.comparator(forKey: key)
        return self.merchandise.sort(comparator)
    }
    
    /** `Merch`andise whose names begin with the given prefix. */
    func merchandise(withNamePrefix prefix: String) -> [Merch]
    {
        return self.merchandise.filter { $0.name.hasPrefix(prefix) }
    }
    
    mutating func purchasingMerch(named name: String, byUnit unit: Unit) -> Merch
    {
        let merch = Merch(named: name, inUnit: unit).purchased()
        self.merchandise.insert(merch)
        return merch
    }
}
