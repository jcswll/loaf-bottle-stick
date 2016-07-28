/**
 * A `Trip` manages `Purchase`s for a `Market`. It represents a current 
 * shopping list: the items the user wants to buy the next time they go to 
 * this store.
 */
struct Trip : MarketList
{
    typealias Item = Purchase
    /** All current purchases */
    var items: Set<Purchase>
    
    /** Creation from provided data */
    init(data: TripData)
    {
        self.items = data.purchases
    }
    
    /** Default (empty) construction */
    init()
    {
        self.items = []
    }
    
    /** Create `Purchase` and add to `purchases`. */
    mutating func createPurchase(ofMerch merch: Merch, 
                                 inQuantity quantity: UInt?)
                 -> Purchase
    {
        let purchase = Purchase(ofMerch: merch, inQuantity: quantity)
        self.items.insert(purchase)
        return purchase
    }
    
    /** 
     * In response to changes in the "old" `Merch`'s fields, find the
     * `Purchase` with the old `Merch` and substitute the "new" `Merch`.
     *
     * It is an error to try to update a nonexistent `Purchase`.
     */
    mutating func updatePurchase(ofMerch old: Merch, to new: Merch) 
                 throws -> Purchase 
    { 
        guard let original = self.purchase(ofMerch: old) else {
            throw MarketListError.ItemNotFound(old)
        }
        
        let updated = original.changingMerch(to: new)
        try! self.delete(original)    // !: Already tested for existence
        self.items.insert(updated)
        return updated
    }
    
    /** Find the `Purchase` that uses `merch`. */
    func purchase(ofMerch merch: Merch) -> Purchase?
    {
        return self.items.firstElement { purchase in purchase.isOf(merch) }
    }
    
    /** Test whether any current `Purchase` uses the given `Merch`. */
    func merchIsUsed(merch: Merch) -> Bool
    {
        return self.purchase(ofMerch: merch) != nil
    }
}
