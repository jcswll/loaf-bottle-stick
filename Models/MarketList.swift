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
     * Add the item to the list.
     *
     * - Throws: `MarketListError.ItemExists`, with the new item associated,
     * if the item is already present in the list.
     */
    mutating func add(item: Item) throws
    {
        guard self.item(forKey: item.searchKey) == nil else {
            throw MarketListError.ItemExists(item)
        }
        self.items.insert(item)
    }

    /**
     * Remove the item from the list.
     *
     * - Throws: `MarketListError.ItemNotFound`, with the item associated, if
     * the item does not exist in the list.
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
     * - Throws: `MarketListError.ItemNotFound`, with the item associated, if
     * the first item does not exist in the list.
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


enum MarketListError<Item: MarketItem> : ErrorType
{
    /**
     * Thrown when an `Item` passed in for deletion or updating is not
     * found in the list.
     */
    case ItemNotFound(Item)

    /**
     * Thrown when an `Item` passed in for addition is already in the list.
     */
    case ItemExists(Item)
}
