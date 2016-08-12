/**
 * A `MarketData` represents a `Market` for archiving. It creates  
 * `MarketListData` instances to represent the `Market`'s `MarketList`s.
 */
class MarketData : Codable
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
    
    convenience required init?(decoder: Decoder)
    {
        let decodedInventory = decoder.decodeCodable(forKey: "inventory")
        let decodedTrip = decoder.decodeCodable(forKey: "trip")
        
        guard 
            let name = decoder.decodeString(forKey: "name"),
            let ident = decoder.decodeString(forKey: "ident"),
            let inventoryData = decodedInventory as? MarketListData<MerchData>,
            let tripData = decodedTrip as? MarketListData<PurchaseData>
        else {

            return nil
        }

        self.init(name: name,
                 ident: ident,
             inventory: inventoryData.marketList,
                  trip: tripData.marketList)
    }
    
    func encode(withEncoder encoder: Encoder)
    {
        encoder.encode(string: self.name, forKey: "name")
        encoder.encode(string: self.ident, forKey: "ident")
        let inventoryData = MarketListData<MerchData>(self.inventory)
        encoder.encode(codable: inventoryData, forKey: "inventory")
        let tripData = MarketListData<PurchaseData>(self.trip)
        encoder.encode(codable: tripData, forKey: "trip")
    }
}
