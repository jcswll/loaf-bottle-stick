struct Trip
{
    mutating func purchase(merch merch: Merch, inQuantity quantity: UInt8?)
    {
        let purchase = Purchase(ofItem: merch, inQuantity: quantity)
        self.purchases.insert(purchase)
    }
    
    mutating func toggleCrossoffPurchase(named name: String)
    {
        let namePredicate = { purchase: Purchase in 
                              purchase.item.name == name }
        guard let purchase = self.purchases.firstElement(namePredicate) else {
            return // error?
        }
        
        self.purchases.insert(purchase.crossedOff())
    }
}