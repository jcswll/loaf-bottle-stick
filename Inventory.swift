/**
 * `Inventory` manages `Merch` for a `Store`:
 * 
 * - Vends `Merch`andise as a list, or only those matching a name prefix.
 * - Adds `Merch` by name to the inventory.
 * - Performs updates to a `Merch`'s fields.
 * - Deletes `Merch`
 */
struct Inventory
{
    private var merchandise: Set<Merch> = []
    
    /** Search `merchandise` for a particular `Merch` by its name. */
    private func merch(named name: String) -> Merch?
    {
        return self.merchandise.firstElement { $0.name == name }
    }
    
    /** 
     * Search for a particular `Merch` by its `name`. 
     * If found, it is removed from `merchandise` and then returned.
     */
    private mutating func popMerch(named name: String) -> Merch?
    {
        guard let found = self.merch(named: name) else {
            return nil
        }
        return self.merchandise.remove(found)
    }
    
}

/** Interface with `Store`.*/
extension Inventory
{        
    /** `Merch`andise whose names begin with the given term. */
    func merchandise(forSearchTerm prefix: String) -> [Merch]
    {
        return self.merchandise.filter { $0.name.hasPrefix(prefix) }
    }
    
    /**
     * Looks for a `Merch` with the given name and changes its unit. If it does 
     * not exist yet, creates it.
     * 
     * The `Merch`'s internal purchase info is updated and it is added to the
     * `Inventory`'s list.
     *
     * Returns the configured `Merch`.
     */
    mutating func purchaseMerch(named name: String, byUnit unit: Unit?) -> Merch
    {
        // Look for Merch by name, removing if found
        let found = self.popMerch(named: name)
        // If found, change unit, otherwise create
        var merch = found?.changingUnit(to: unit) ?? 
                        Merch(named: name, inUnit: unit)
        // Track purchase, and replace in set
        merch.purchase()
        self.merchandise.insert(merch)
        
        return merch
    }
}

/** View on internal list */
extension Inventory
{
    /** All `Merch`, sorted by the given key. */
    func merchandise(sortedBy key: Merch.SortKey) -> [Merch]
    {
        let comparator = Merch.comparator(forKey: key)
        return self.merchandise.sort(comparator)
    }
}

/** Updating */
extension Inventory 
{
    enum InventoryError : ErrorType
    {
        /** Error for a failed `Merch` search when trying to update. */
        case MerchNameNotFound(String)
    }
    
    /** 
     * Changes the name of the `Merch` with the given name to `newName`.
     *
     * If no `Merch` is found, throws a .MerchNameNotFound error.
     *
     * Returns the updated `Merch`.
     */
    mutating func renameMerch(named name: String, to newName: String) 
            throws -> Merch
    {
        guard let merch = self.popMerch(named: name)?.changingName(to: newName) 
        else {
            throw InventoryError.MerchNameNotFound(name)
        }
        self.merchandise.insert(merch)
        return merch
    }
    
    /** 
     * Changes the unit of the `Merch` with the given name.
     *
     * If no `Merch` is found, throws a .MerchNameNotFound error.
     *
     * Returns the updated `Merch`.
     */
    mutating func setUnitForMerch(named name: String, to unit: Unit) 
            throws -> Merch
    {
        guard let merch = self.popMerch(named: name)?.changingUnit(to: unit)
        else {
            throw InventoryError.MerchNameNotFound(name)
        }
        self.merchandise.insert(merch)
        return merch
    }
}
