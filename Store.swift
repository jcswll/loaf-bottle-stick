import Foundation

typealias UniqueID = String

/**
 * A `Store` manages an inventory of `Merch` and a list of `Purchase`s.
 */
public struct Store
{
    /** The name of the represented shop, as entered by the user. */
    public var name: String
    /** Unique identifier for internal bookkeeping. */
    private let ident: UniqueID = NSUUID().UUIDString
    /** The store's list of `Merch` that have been purchased in the past. */
    private var inventory = Inventory()
    /** The store's shopping list: the `Merch` that need to be purchased. */
    private var trip = Trip()
    /** 
     * Map a Merch to the quantity last purchased, so that it can be suggested
     * when purchasing again.
     */
    private var lastQuantities = Dictionary<Merch, UInt>()
    
    public init(named name: String)
    {
        self.name = name
    }

    /**
     * Create a purchase record for an item of the given name and optional
     * amount to buy.
     * A new `Merch` is created if necessary in the inventory.
     * The used quantity is recorded for future reference.
     */
    public mutating func purchaseMerch(named name: String, 
                                       inQuantity quantity: UInt?,
                                       byUnit unit: Unit?)
    {
        // Ask inventory for proper Merch,
        let merch = self.inventory.purchaseMerch(named: name, byUnit: unit)
        // Give purchase info to trip
        self.trip.addPurchase(ofMerch: merch, inQuantity: quantity)
        // Update lastQuantities
        if let quantity = quantity {
            self.lastQuantities[merch] = quantity
        }
    }
}

// Querying
extension Store
{
    /**
     * Given a string that may be a subsequence of a Merch's name, return
     * matching names, along with any stored previous quantities.
     */
    public struct MerchMeasure
    {
        let unit: Unit
        let quantity: UInt
    }
    public func suggestedMerchInfo(forTerm prefix: String) 
      -> AnySequence<(name: String, measure: MerchMeasure?)>
    {
        let merchandise = self.inventory.merchandise(forSearchTerm: prefix)
        let names = merchandise.map { $0.name }
        let measures: [MerchMeasure?] 
        measures = merchandise.map { merch in
            guard let quantity = self.lastQuantities[merch] else {
                return nil
            }
            
            return MerchMeasure(unit: merch.unit, quantity: quantity)
        }
        
        return AnySequence(zip(names, measures))
    }
}
