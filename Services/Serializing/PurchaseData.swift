/** The data representation of a `Purchase`. */
class PurchaseData : MarketItemData
{
    /** The `Merch` of the `Purchase` */
    let merch: Merch
    /** The `Purchase`'s `note` */
    let note: String?
    /** The `Purchase`'s quantity */
    let quantity: UInt
    /** The `Purchase`'s state of being checked off the list */
    let isCheckedOff: Bool

    /** The `Purchase` represented by this data. */
    var item: Purchase {
        
        return Purchase(merch: self.merch,
                         note: self.note,
                     quantity: self.quantity,
                   checkedOff: self.isCheckedOff)
    }

    /** Create by composing from given field values */
    init(merch: Merch, note: String?, quantity: UInt, checkedOff: Bool)
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

    /** Create from data provided by the given decoder. */
    convenience required init?(decoder: Decoder)
    {
        guard
            let merchDecoded = decoder.decodeCodable(forKey: "merch"),
            let merchData = merchDecoded as? MerchData,
            let note = decoder.decodeString(forKey: "note"),
            let quantity = decoder.decodeUnsignedInt(forKey: "quantity"),
            let checkedOff = decoder.decodeBool(forKey: "checkedOff")
        else {

            return nil
        }

        self.init(merch: merchData.item,
                   note: (note != "") ? note : nil,
               quantity: quantity,
             checkedOff: checkedOff)
    }

    /** Provide data to the encoder for archiving. */
    func encode(withEncoder encoder: Encoder)
    {
        encoder.encode(codable: MerchData(item: self.merch), forKey: "merch")
        encoder.encode(string: self.note ?? "", forKey: "note")
        encoder.encode(unsignedInt: self.quantity, forKey: "quantity")
        encoder.encode(bool: self.isCheckedOff, forKey: "checkedOff")
    }
}

private extension Purchase
{
    init(merch: Merch, note: String?, quantity: UInt, checkedOff: Bool)
    {
        self.merch = merch
        self.note = note
        self.quantity = quantity
        self.isCheckedOff = checkedOff
    }
}
