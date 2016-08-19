/**
 * An data object representing a `MarketItem` for serialization.
 */
protocol MarketItemData : class, Codable
{
    /** The item type that this data represents. */
    associatedtype Item : MarketItem

    /** Decompose an instance of the represented item for serializing. */
    init(item: Item)

    /** Construct an instance of the represented item from data.  */
    var item: Item { get }
}
