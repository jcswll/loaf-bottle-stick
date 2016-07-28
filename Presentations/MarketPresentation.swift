/** Present a `Market` in a way that's consumable in a CLI environment. */
class MarketPresentation
{
    private var market: Market
    
    init(market: Market)
    {
        self.market = market
    }
    
    /** Market name */
    var name: String 
    { 
        get { return self.market.name }
        set(name)
        { 
            self.market.name = name
            self.didUpdate?() 
        }
    }
    
    var didUpdate: (() -> Void)?
    // MARK: - Events
    
    lazy var inventoryPresentation: InventoryPresentation = {
        // Create 
        let presentation = 
               InventoryPresentation(inventory: self.market.inventory)
        // Chain events
        //TODO: Need shouldPurchase. Ties to Quick Entry?
        presentation.makePurchase = { [weak self] (merch, quantity) in 
            //TODO: Need quantity
            self?.tripPresentation.createPurchase(ofMerch: merch, 
                                              inQuantity: quantity)
        }
        presentation.merchDidChange = { [weak self] (old, new) in
            do {
                try self?.tripPresentation.updatePurchase(ofMerch: old, 
                                                               to: new)
            }
            catch _ {
                fatalError("Attempt to update nonexistent purchase of \(old.name)")
            }
        }
        presentation.merchIsInPurchase = { [weak self] (merch) in 
            guard let `self` = self else {
                return false
            }
            return self.tripPresentation.merchIsUsed(merch)
        }
        presentation.didDeleteMerch = { [weak self] (merch) in
            do {
                try self?.tripPresentation.deletePurchase(ofMerch: merch)
            }
            catch _ {
                fatalError("Attempt to delete nonexistent purchase of \(merch.name)")
            }
        }
        // didCreateMerch?
        return presentation
    }()
    
    lazy var tripPresentation: TripPresentation = {
        let presentation = TripPresentation(trip: self.market.trip)
        // purchaseDidChange?
        return presentation
    }()
    
    // Switch subpresentation
}
