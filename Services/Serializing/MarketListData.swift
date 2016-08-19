/**
 * A `MarketListData` instance represents a `MarketList` for serializing.
 * It can construct an appropriately specialized `MarketList` after
 * unarchiving its information.
 */
class MarketListData<ItemData : MarketItemData> : Codable
{
    /** The items of the `MarketList` */
    let items: Set<ItemData.Item>

    /** Construct a new `MarketList` from the stored items. */
    var marketList: MarketList<ItemData.Item> {
        return MarketList(items: self.items)
    }

    /** Create with a set of items. */
    init(items: Set<ItemData.Item>)
    {
        self.items = items
    }

    /** Create by decomposing an existing `MarketList`. */
    convenience init(_ list: MarketList<ItemData.Item>)
    {
        self.init(items: list.items)
    }

    /** Create from the archive provided by the given decoder. */
    convenience required init?(decoder: Decoder)
    {
        // Items are stored as their representative `MarketItemData`.
        let decodedItems = decoder.decodeArray(forKey: "items")
        guard let itemData = decodedItems as? [ItemData] else { return nil }

        // Transform to the appropriate `MarketItem` type.
        let items = Set<ItemData.Item>(itemData.map { $0.item })

        self.init(items: items)
    }

    /** Save into an archive using the given encoder. */
    func encode(withEncoder encoder: Encoder)
    {
        // `MarketItem`s cannot be encoded directly; transform to
        // the representative `MarketItemData`
        let itemsData = self.items.map { ItemData(item: $0) }
        encoder.encode(array: itemsData, forKey: "items")
    }
}
