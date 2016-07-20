/** Present a `Merch` in a way that's consumable in a CLI environment. */
class MerchTextPresentation : Presentation
{
    typealias Presented = Merch
    var parent: InventoryTextPresentation?
    
    /** `Merch` fields: name, unit */
}

/** Updating merch's properties from input: name, unit */