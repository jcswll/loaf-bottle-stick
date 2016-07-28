/** Exposes the essential fields of a `Merch` when user makes a `Purchase`. */
struct MerchInfo
{
    let name: String
    let unit: Unit?
    let quantity: UInt?
    
    init(_ merch: Merch)
    {
        self.name = merch.name
        self.unit = merch.unit
        self.quantity = 0
    }
}