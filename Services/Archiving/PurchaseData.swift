import class Foundation.NSCoder

/** The data representation of a `Purchase`. */
class PurchaseData : MarketItemData
{
    /** The `Merch` of the `Purchase` */
    let merch: Merch
    /** The `Purchase`'s `note` */
    let note: String?
    /** The `Purchase`'s quantity */
    let quantity: UInt?
    /** The `Purchase`'s state of being checked off the list */
    let isCheckedOff: Bool
    
    var item: Purchase { return Purchase(merch: self.merch,
                                          note: self.note,
                                      quantity: self.quantity,
                                    checkedOff: self.isCheckedOff)
    }


    /** Create by composing from given field values */
    init(merch: Merch, note: String?, quantity: UInt?, checkedOff: Bool)
    {
        self.merch = merch
        self.note = note
        self.quantity = quantity
        self.isCheckedOff = checkedOff
    }

    /** Create by decomposing an existing `Purchase`. */
    required init(item: Purchase)
    {
        self.merch = item.merch
        self.note = item.note
        self.quantity = item.quantity
        self.isCheckedOff = item.isCheckedOff
    }
    
    @objc convenience required init?(coder: NSCoder)
    {
        guard let merchData = (coder.decodeObjectForKey("merch") as? MerchData),
              let note = (coder.decodeObjectForKey("note") as? String)
        else {
            
            return nil
        }
        
        let quantity: UInt = UInt(coder.decodeIntegerForKey("quantity"))
        let checkedOff = coder.decodeBoolForKey("checkedOff")
        
        self.init(merch: merchData.item,
                   note: (note != "") ? note : nil, 
               quantity: (quantity != 0) ? quantity : nil,
             checkedOff: checkedOff)
    }
    
    @objc func encodeWithCoder(coder: NSCoder)
    {
        coder.encodeObject(MerchData(item: self.merch), forKey: "merch")
        coder.encodeObject(self.note ?? "", forKey: "note")
        coder.encodeInteger(Int(self.quantity ?? 0), forKey: "quantity")
        coder.encodeBool(self.isCheckedOff, forKey: "checkedOff")
    }
}
