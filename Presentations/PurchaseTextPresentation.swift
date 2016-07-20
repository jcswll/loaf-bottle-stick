/** Present a `Purchase` in a way that's consumable in a CLI environment. */
class PurchaseTextPresentation : Presentation
{
    typealias Presented = Purchase
    var parent: TripTextPresentation?
    
    /** Sub-presentation: MerchTextPresentation */
    /** `Purchase` fields: quantity, note, crossed off */
}

/** Updating purchase's properties from input: quantity, note, crossed off */