import Foundation
/**
 * A `Market` is a container for a list of `Merch` (the "inventory"),
 * and a list of `Purchases` (a "trip").
 * It represents a place the user goes to buy things.
 */
struct Market
{
    typealias UniqueID = String

    /** Name of place, as entered by and displayed to the user. */
    var name: String
    /** Unique identifier to facilitate data retrieval. */
    let ident: UniqueID
    /** The market's list of `Merch` that have been purchased in the past. */
    private(set) var inventory: MarketList<Merch>
    /** The current shopping list: the `Purchase`s that need to be made. */
    private(set) var trip: MarketList<Purchase>

    /** Creation with a name: `inventory` and `trip` are new and empty. */
    init(name: String)
    {
        self.name = name
        self.ident = NSUUID().UUIDString
        self.inventory = MarketList()
        self.trip = MarketList()
    }

    /** Creation from given field values */
    init(name: String,
         ident: Market.UniqueID,
         inventory: MarketList<Merch>,
         trip: MarketList<Purchase>)
    {
        self.name = name
        self.ident = ident
        self.inventory = inventory
        self.trip = trip
    }
}

// Markets can be compared by identifier.
func ==(lhs: Market, rhs: Market) -> Bool
{
    return lhs.ident == rhs.ident
}

extension Market : Equatable {}
