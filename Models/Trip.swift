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
}
