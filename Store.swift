/**
 * A `Store` manages an inventory of `Merch` and a list of `Purchase`s,
 * vending lists or individual items as needed.
*/
struct Store
{
    var name: String
    private var inventory = Inventory()
    private var trip = Trip()
    /** 
     * Map a Merch to the quantity last purchased, so that it can be suggested
     * when purchasing again.
     */
    private var lastQuantities = Dictionary<Merch, UInt>()
    
    init(named name: String)
    {
        self.name = name
    }
    
    /**
     * Given a string that may be a prefix of a Merch's name, return matches
     * along with any stored previous quantities.
     */
    struct MerchMeasure
    {
        let unit: Unit
        let quantity: UInt
    }
    func suggestedMerchInfo(forPrefix prefix: String) 
      -> [(name: String, measure: MerchMeasure?)]
    {
        let merchandise = self.inventory.merchandise(withNamePrefix: prefix)
        let measures = merchandise.map { merch in
            guard let quantity = self.lastQuantities[merch] else {
                return nil
            }
            
            return MerchMeasure(unit: merch.unit, quantity: quantity)
        }
        return zip(merchandise.map { $0.name }, measures)
    }

    
    func purchaseMerch(named name: String, 
                       inQuantity quantity: UInt? = nil,
                       byUnit unit: Unit? = nil)
    {
        // Ask inventory for corresponding Merch,
        let merch = self.inventory.purchasingMerch(named: name, byUnit: unit)
        // Give Purchase info to trip
        self.trip.purchase(merch: merch, inQuantity: quantity)
        // Update lastQuantities
        if let quantity = quantity {
            self.lastQuantities[merch] = quantity
        }
    }
}
