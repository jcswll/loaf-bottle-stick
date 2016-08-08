import protocol Foundation.NSCoding
import class Foundation.NSCoder

/**
 * A `MarketListData` instance represents a `MarketList` for archiving and
 * retrieval. It can construct an appropriately specialized `MarketList`
 * after unarchiving its information.
 */
class MarketListData<Item : MarketItem, ItemData : MarketItemData 
                     where ItemData.Item == Item, Item.Data == ItemData>
                    : NSCoding
//!!!: Declaring NSCoding conformance in an extension causes the compiler 
//!!!: (v2.2) to segfault. Unfortunately, the ugly decl has to stay here.
{
    /** The items of the `MarketList` */
    let items: Set<Item>
    
    /** Construct a new `MarketList` from the stored items. */
    var marketList: MarketList<Item> { 
        return MarketList(items: self.items) 
    }
    
    /** Create with a set of items. */
    init(items: Set<Item>)
    {
        self.items = items
    }
    
    /** Create by decomposing an existing `MarketList`. */
    convenience init(_ list: MarketList<Item>)
    {
        self.init(items: list.items)
    }
    
    /** Create from the archive provided by the given decoder. */
    @objc convenience required init?(coder: NSCoder)
    {
        // Items are stored as their representative `MarketItemData`.
        let decodedItems = coder.decodeObjectForKey("items")
        guard let itemData = decodedItems as? [ItemData] else {
            
            return nil
        }
        
        // Transform to the appropriate `MarketItem` type.
        let items = Set<Item>(itemData.map { $0.item })
        
        self.init(items: items)
    }
    
    /** Save into an archive using the given encoder. */
    @objc func encodeWithCoder(coder: NSCoder)
    {
        // `MarketItem`s cannot be encoded directly; transform to
        // the representative `MarketItemData`
        let itemsData = self.items.map { ItemData(item: $0) }
        coder.encodeObject(itemsData, forKey: "items")
    }
}
