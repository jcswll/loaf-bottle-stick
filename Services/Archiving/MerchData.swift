import Foundation

/** The data representation of a `Merch`. */
struct MerchData : MarketItemData
{
    /** The name of the `Merch` */
    let name: String
    /** The `Merch`'s unit */
    let unit: Unit
    /** The `Merch`'s internal usage count */
    let numUses: UInt
    /** The `Merch`'s internal last usage date */
    let lastUsed: NSDate
    
    /** Create by composing from given field values */
    init(name: String, unit: Unit, numUses: UInt, lastUsed: NSDate)
    {
        self.name = name
        self.unit = unit 
        self.numUses = numUses
        self.lastUsed = lastUsed
    }
    
    /** Create by decomposing an existing `Merch`. */
    init(item: Merch)
    {
        self.name = item.name
        self.unit = item.unit
        self.numUses = item.numUses
        self.lastUsed = item.lastUsed
    }
}
