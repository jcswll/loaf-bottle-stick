/**
 * `MarketData` represets an archive of some kind of an `Market`; it exposes 
 * the information that a `Market` needs to construct itself.
 */
struct MarketData
{
    /** The name of the market. */
    let name: String
    /** The UUID of the market. */
    let ident: Market.UniqueID
    /** The data to construct the market's inventory. */
    let inventoryData: InventoryData
    /** The data to construct the market's trip. */
    let tripData: TripData
}