import class Foundation.NSDate

/** The data representation of a `Merch`. */
class MerchData : MarketItemData
{
    /** The name of the `Merch` */
    let name: String
    /** The `Merch`'s unit */
    let unit: Unit
    /** The `Merch`'s internal usage count */
    let numUses: UInt
    /** The `Merch`'s internal last usage date */
    let lastUsed: NSDate
    
    /** The `Merch` represented by this data. */
    var item: Merch { return Merch(name: self.name,
                                   unit: self.unit,
                                numUses: self.numUses,
                               lastUsed: self.lastUsed)
    }
    
    /** Create by composing from given field values */
    init(name: String, unit: Unit, numUses: UInt, lastUsed: NSDate)
    {
        self.name = name
        self.unit = unit 
        self.numUses = numUses
        self.lastUsed = lastUsed
    }
    
    /** Create by decomposing an existing `Merch`. */
    required init(item: Merch)
    {
        self.name = item.name
        self.unit = item.unit
        self.numUses = item.numUses
        self.lastUsed = item.lastUsed
    }
    
    /** Create from data provided by the given decoder. */
    convenience required init?(decoder: Decoder)
    {
        guard 
            let name = decoder.decodeString(forKey: "name"),
            let unitName = decoder.decodeString(forKey: "unit"),
            let unit = Unit(rawValue: unitName),
            let lastUsed = decoder.decodeDate(forKey: "lastUsed"),
            let numUses = decoder.decodeUnsignedInt(forKey: "numUses")
        else {
            
            return nil
        }
        
        self.init(name: name, 
                  unit: unit, 
               numUses: numUses, 
              lastUsed: lastUsed)
    }
    
    /** Provide data to the encoder for archiving. */
    func encode(withEncoder encoder: Encoder)
    {
        encoder.encode(string: self.name, forKey: "name")
        encoder.encode(string: self.unit.rawValue, forKey: "unit")
        encoder.encode(unsignedInt: self.numUses, forKey: "numUses")
        encoder.encode(date: self.lastUsed, forKey: "lastUsed")
    }
}

private extension Merch
{
    init(name: String, unit: Unit, numUses: UInt, lastUsed: NSDate)
    {
        self.name = name   
        self.unit = unit
        self.numUses = numUses
        self.lastUsed = lastUsed
    }
}
