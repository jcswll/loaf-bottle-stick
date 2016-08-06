/** 
 * An object representing a `MarketItem`, for archiving and retrieval.
 *
 * Each adopter should expose all the fields its represented type needs
 * to initialize itself in the `MarketItem` method `init(data:)`. 
 */
protocol MarketItemData 
{
    /** The item type that this data represents. */
    associatedtype Item   // : MarketItem, but circular conformance is an error
    /** Create from an instance of the represented item; for archiving. */
    init(item: Item)
}
