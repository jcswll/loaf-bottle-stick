/** 
 * An object representing a `MarketItem`, for archiving and retrieval.
 * 
 */
protocol MarketItemData : class, Decodable, Encodable
{
    /** The item type that this data represents. */
    associatedtype Item : MarketItem
    
    /** Decompose an instance of the represented item for archiving. */
    init(item: Item)
    
    /** Construct an instance of the represented item from data.  */
    var item: Item { get }
}
