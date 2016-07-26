import Foundation
/**
 * A `Market` is a container for a list of `Merch`: the `Inventory`,
 * and a list of `Purchases`: a `Trip`.
 * It represents a place the user goes to buy things.  
 */
struct Market
{
    typealias UniqueID = String

    /** Name of place, as entered by and displayed to the user. */
    var name: String
    /** Unique identifier to facilitate data retrieval. */
    private let ident: UniqueID
    /** The market's list of `Merch` that have been purchased in the past. */
    private(set) var inventory: Inventory
    /** The current shopping list: the `Purchase`s that need to be made. */
    private(set) var trip: Trip

    /** Creation with a name: `inventory` and `trip` are new and empty. */
    init(name: String)
    {
        self.name = name
        self.ident = NSUUID().UUIDString
        self.inventory = Inventory()
        self.trip = Trip()
    }
    
    /** Creation from injected data. */
    init(provider: MarketData)
    {
        self.name = provider.name
        self.ident = provider.ident
        self.inventory = Inventory(data: provider.inventoryData)
        self.trip = Trip(data: provider.tripData)
    }
}

/** Mutation (name) */

/** Archiving */