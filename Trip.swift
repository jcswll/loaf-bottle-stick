/**
 * `Trip` manages `Purchase`s for a `Store`:
 * 
 * - Accepts orders to create new `Purchase`s.
 * - Vends all `Purchase`s as a sorted list.
 * - Performs updates to a `Purchase`'s fields, especially whether it is
 * "crossed off".
 */
struct Trip
{
    private var purchases: Set<Purchase> = []
    
    /** All `Purchase`s, sorted by their `Merch` on the given key. */
    func purchases(sortedBy key: Merch.SortKey) -> [Purchase]
    {
        let comparator = Merch.comparator(forKey: key)
        return self.purchases.sort { comparator($0.merch, $1.merch) }
    }
    
    /** 
     * Search for a particular `Purchase` by its `Merch`'s `name`. 
     * If found, it is removed from `purchases` and then returned.
     */
    private mutating func popPurchase(named name: String) -> Purchase?
    {
        let namePredicate = { (purchase: Purchase) -> Bool in 
                                    purchase.merch.name == name }
        guard let found = self.purchases.firstElement(passing: namePredicate) 
        else {
            return nil
        }
        
        return self.purchases.remove(found)
    }
}

// Interface with `Store`
extension Trip
{
    /** Create a purchase record for the given `Merch` and amount. */
    mutating func addPurchase(ofMerch merch: Merch, inQuantity quantity: UInt?)
    {
        let purchase = Purchase(ofMerch: merch, inQuantity: quantity)
        self.purchases.insert(purchase)
    }
}

// Updating
extension Trip
{
    enum TripError : ErrorType
    {
        /** Error for a failed `Merch` search when trying to update. */
        case PurchaseNameNotFound(String)
    }
    
    /**
     * Find `Purchase` by name of its `Merch` and change its "crossed off"
     * status.
     *
     * If no `Merch` is found, throws a .MerchNameNotFound error.
     *
     * Returns the updated `Purchase`.
     */
    mutating func toggleCrossOff(ofPurchaseNamed name: String) throws 
                 -> Purchase
    {
        guard var purchase = self.popPurchase(named: name) else {
            throw TripError.PurchaseNameNotFound(name)
        }
        
        switch purchase.isCrossedOff 
        {
            case true:
                purchase.uncross()
            case false:
                purchase.crossOff()
        }
        
        self.purchases.insert(purchase)
        return purchase
    }
}
