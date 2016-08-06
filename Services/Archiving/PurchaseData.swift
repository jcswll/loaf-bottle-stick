/** The data representation of a `Purchase`. */
struct PurchaseData : MarketItemData
{
    /** The `Merch` of the `Purchase` */
    let merch: Merch
    /** The `Purchase`'s `note` */
    let note: String?
    /** The `Purchase`'s quantity */
    let quantity: UInt?
    /** The `Purchase`'s state of being checked off the list */
    let isCheckedOff: Bool
    
    
    /** Create by composing from given field values */
    init(merch: Merch, note: String?, quantity: UInt?, checkedOff: Bool)
    {
        self.merch = merch
        self.note = note
        self.quantity = quantity
        self.isCheckedOff = checkedOff
    }

    /** Create by decomposing an existing `Purchase`. */
    init(item: Purchase)
    {
        self.merch = item.merch
        self.note = item.note
        self.quantity = item.quantity
        self.isCheckedOff = item.isCheckedOff
    }
}
