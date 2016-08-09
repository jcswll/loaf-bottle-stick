/** 
 * A `MarketList` manages a collection of `MarketItem`s, creating them,
 * performing updates, and handling requests for deletion.
 */
struct MarketList<Item: MarketItem>
{
    /** The inner collection of managed items. */
    private(set) var items: Set<Item>
    
    /** Default creation, empty collection of items. */
    init()
    {
        self.items = []
    }
    
    init(items: Set<Item>)
    {
        self.items = items
    }
    
    /**
     * Remove the item from the list.
     *
     * It is an error to request deletion of an item that does not exist.
     */
    mutating func delete(item: Item) throws
    {
        guard let _ = self.items.remove(item) else {
            throw MarketListError.ItemNotFound(item)
        }
    }
    
    /** 
     * Replace the old item with the new. 
     *
     * It is an error to try to update an nonexistent item. 
     */
    mutating func update(item: Item, to replacement: Item) throws
    {
        guard let _ = self.items.remove(item) else {
            throw MarketListError.ItemNotFound(item)
        }
        self.items.insert(replacement)
    }
    
    /** Find the item matching the given key in the collection. */
    func item(forKey key: Item.SearchKey) -> Item?
    {
        return self.items.firstElement { $0.hasKey(key) }
    }
}

/** `MarketList`s can be compared by their enclosed collections. */
func ==<Item>(lhs: MarketList<Item>, rhs: MarketList<Item>) -> Bool
{
    return lhs.items == rhs.items
}

extension MarketList : Equatable {}
