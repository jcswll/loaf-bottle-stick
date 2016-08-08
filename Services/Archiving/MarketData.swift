import class Foundation.NSCoder

/**
 * A `MarketData` represents a `Market` for archiving. It contains
 * `MarketListData` for the `Market`'s `MarketList`s.
 */
class MarketData
{
    /** The `Market`'s name */
    let name: String
    /** The `Market`'s unique identifier. */
    let ident: Market.UniqueID
    /** The `Market`'s inventory */
    let inventory: MarketList<Merch>
    /** The `Market`'s trip */
    let trip: MarketList<Purchase>
    
    var market: Market { return Market(name: self.name,
                                      ident: self.ident,
                                  inventory: self.inventory,
                                       trip: self.trip)
    }

    /** Create from given field values */
    init(name: String, 
         ident: Market.UniqueID, 
         inventory: MarketList<Merch>, 
         trip: MarketList<Purchase>) 
    {
        self.name = name
        self.ident = ident
        self.inventory = inventory
        self.trip = trip
    }
    
    /** Create by packing up an existing `Market`. */
    init(_ market: Market)
    {
        self.name = market.name
        self.ident = market.ident
        self.inventory = market.inventory
        self.trip = market.trip
    }
    
    @objc convenience init?(coder: NSCoder)
    {
        let codedInventory = coder.decodeObjectForKey("inventory")
        let codedTrip = coder.decodeObjectForKey("trip")
        
        guard let name = (coder.decodeObjectForKey("name") as? String),
              let ident = (coder.decodeObjectForKey("ident") as? String),
              let inventoryData = codedInventory as? MarketListData<MerchData>,
              let tripData = codedTrip as? MarketListData<PurchaseData>
        else {

            return nil
        }

        self.init(name: name,
                 ident: ident,
             inventory: inventoryData.marketList,
                  trip: tripData.marketList)
    }
    
    @objc func encodeWithCoder(coder: NSCoder)
    {
        coder.encodeObject(self.name, forKey: "name")
        coder.encodeObject(self.ident, forKey: "ident")
        let inventoryData = MarketListData<MerchData>(self.inventory)
        coder.encodeObject(inventoryData, forKey: "inventory")
        let tripData = MarketListData<PurchaseData>(self.trip)
        coder.encodeObject(tripData, forKey: "trip")
    }
}
