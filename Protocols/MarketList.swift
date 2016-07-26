
protocol MarketItem : Sortable {}

/**
 * A `MarketList` manages a collection of `MarketItem`s, accepting updates
 * to members and requests for deletion.
 */
protocol MarketList
{
    /** The type that this `MarketList` manages. */
    associatedtype Item: MarketItem
    /** The type of the inner collection that this `MarketList` manages. */
    associatedtype ItemCollection: MarketCollection
    
    /** Inner collection of managed items. */
    var items: ItemCollection { get set }
    
    /**
     * Delete the item.
     *
     * Requesting deletion of an item that does not exist raises an 
     * ItemNotFound error.
     */
    mutating func delete(item: Item) throws
    
    /** Replace the old value with the new. */
    mutating func update(item: Item, to replacement: Item)
}

/** A `MarketCollection` directly holds the items managed by a `MarketList`. */
protocol MarketCollection : CollectionType
{
    /** Add the item to the collection in a self-determined location. */
    mutating func insert(member: Generator.Element)
    /** Remove the item and return it if it was present. */
    mutating func remove(member: Generator.Element) -> Generator.Element?
}

enum MarketListError<Item: MarketItem> : ErrorType
{
    case ItemNotFound(Item)
}

extension MarketList where ItemCollection.Generator.Element == Item
{
    /**
     * Delete the item. It is an error to request deletion of an item
     * that does not exist.
     */
    mutating func delete(item: Item) throws
    {
        guard let _ = self.items.remove(item) else {
            throw MarketListError.ItemNotFound(item)
        }
    }
    
    /** Replace the old value with the new. */
    mutating func update(item: Item, to replacement: Item)
    {
        let _ = self.items.remove(item)
        self.items.insert(replacement)
    }
}
