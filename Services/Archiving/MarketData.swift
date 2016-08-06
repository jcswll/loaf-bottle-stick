/**
 * A `MarketData` represents a `Market` for archiving. It contains
 * `MarketListData` for the `Market`'s `MarketList`s.
 */
struct MarketData
{
    /** The `Market`'s name */
    let name: String
    /** The `Market`'s unique identifier. */
    let ident: Market.UniqueID
    /** Data for the `Market`'s inventory */
    let inventory: MarketListData<MerchData>
    /** Data for the `Market`'s trip */
    let trip: MarketListData<PurchaseData>

    /** Create from given field values */
    init(name: String, 
         ident: Market.UniqueID, 
         inventory: MarketListData<MerchData>, 
         trip: MarketListData<PurchaseData>) 
    {
        self.name = name
        self.ident = ident
        self.inventory = inventory
        self.trip = trip
    }
    
    /** Create by packing up an existing `Market`. */
    init(market: Market)
    {
        self.name = market.name
        self.ident = market.ident
        self.inventory = MarketListData(list: market.inventory)
        self.trip = MarketListData(list: market.trip)
    }
}
