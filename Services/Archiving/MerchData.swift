import class Foundation.NSDate
import class Foundation.NSCoder

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
    @objc convenience required init?(coder: NSCoder)
    {
        guard let name = (coder.decodeObjectForKey("name") as? String),
              let unitName = (coder.decodeObjectForKey("unit") as? String),
              let unit = Unit(rawValue: unitName),
              let lastUsed = (coder.decodeObjectForKey("lastUsed") as? NSDate)
        else {
            
            return nil
        }
        
        let numUses = UInt(coder.decodeIntegerForKey("numUses"))
        self.init(name: name, 
                  unit: unit, 
               numUses: numUses, 
              lastUsed: lastUsed)
    }
    
    /** Provide data to the encoder for archiving. */
    @objc func encodeWithCoder(coder: NSCoder)
    {
        coder.encodeObject(self.name, forKey: "name")
        coder.encodeObject(self.unit.rawValue, forKey: "unit")
        coder.encodeInteger(Int(self.numUses), forKey: "numUses")
        coder.encodeObject(self.lastUsed, forKey: "lastUsed")
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
