/** 
 * An object in a `MarketList`.
 *
 * Hashable and sortable; defines its own search key so that it can be located
 * by the list. 
 */
protocol MarketItem: Sortable, Hashable
{    
    /** The type used to find this item in its containing `MarketList`. */
    associatedtype SearchKey
    /** The actual value that the item can be found by. */
    var searchKey: SearchKey { get }
    /** Allow the item to perform its own test to determine matching by key. */
    func hasKey(key: SearchKey) -> Bool 
}

/** For SearchKeys that are Equatable, default to equality when searching. */
extension MarketItem where SearchKey: Equatable
{
    func hasKey(key: SearchKey) -> Bool 
    {
        return self.searchKey == key
    }
}

/** For SearchKeys that are Hashable, default to searchKey for hash. */
extension MarketItem where SearchKey: Hashable
{
    var hashValue: Int { return self.searchKey.hashValue }
}
