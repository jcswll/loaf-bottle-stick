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
    
    /** Creation from provided data. */
    init<ItemData: MarketItemData where ItemData.Item == Item>
        (data: MarketListData<ItemData>)
    {
        self.items = Set(data.itemData.map { 
            // The constraints on this constructor paired with the constraints
            // on the `MarketListData` constructor make this cast safe, but
            // it's probably beyond the solver to figure that out.
            Item(data: ($0 as! Item.Data)) 
        })
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
    
    /** 
     * Use the passed data to create a new item, add it to the list, and then 
     * return it.
     */
    mutating func createItem<ItemData: MarketItemData where 
                             ItemData.Item == Item>
                            (from data: ItemData) 
                 -> Item
    {
        guard let data = (data as? Item.Data) else {
            fatalError("Attempt to create value of type \(Item.self) from " +
                       "value of wrong type \(ItemData.self)")
        }
        let item = Item(data: data)
        self.items.insert(item)
        return item
    }
    
    /** Find the item matching the given key in the collection. */
    func item(forKey key: Item.SearchKey) -> Item?
    {
        return self.items.firstElement { $0.hasKey(key) }
    }
}
