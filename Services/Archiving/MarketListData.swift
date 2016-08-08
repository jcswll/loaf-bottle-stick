import class Foundation.NSCoder

/**
 * A `MarketListData` instance represents a `MarketList` for archiving and
 * retrieval. The contained items are `MarketItemData` instances of the
 * appropriate type.
 */
class MarketListData<ItemData: MarketItemData> : NSCoder
{
    let itemData: [ItemData]
    
    /** Create from a list of `MarketItemData` instances. */
    init(itemData: [ItemData])
    {
        self.itemData = itemData
    }
    
    /** Create by decomposing an existing `MarketList`. */
    init<Item: MarketItem where Item.Data == ItemData>(list: MarketList<Item>)
    {
        self.itemData = list.items.map {
            // The constraints on this constructor paired with the constraints
            // on the `MarketList` constructor make this cast safe, but it's
            // probably beyond the solver to figure that out.
            ItemData(item: ($0 as! ItemData.Item)) 
        }
    }
}
