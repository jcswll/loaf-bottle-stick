/** Present a `Trip` in a way that's consumable in a CLI environment. */
class TripPresentation
{
    private var trip: Trip
    
    init(trip: Trip)
    {
        self.trip = trip
    }
    
    // MARK: - Fields
    var sortKey: Merch.SortKey = .Name  { didSet { self.didChangeOrder?() }}
    //FIXME: Ignoring sort for the moment
    /** Sorted list of `Presentation`s for all trip's items */
    var purchasePresentations: [PurchasePresentation] = []
    
    //TODO: Split list
    /** Optionally split display by checked-off status. */

    // MARK: - Events
    /** Tell view that new values need to be read. */
    var didUpdate: (() -> Void)?
    // FIXME: Are these redundant?
    /** Tell view that the full list needs to be read. */
    var didChangeOrder: (() -> Void)?
    /** Notify observer of a change to a contained `Purchase`. */
    var purchaseDidChange: ((Purchase, Purchase) -> Void)?
    
    func load()
    {
        self.purchasePresentations = self.trip.items.map { 
            self.presentation(forPurchase: $0) 
        } 
    }
    
    /** Create an item. */
    // This is a model-layer event, not initiated by the view
    func createPurchase(ofMerch merch: Merch, inQuantity quantity: UInt?)
    {
        //TODO: Handle duplicate purchases
        // let purchase = self.trip.createPurchase(ofMerch: merch,
        //                                      inQuantity: quantity)
        // Create presentation
        // let presentation = self.presentation(forPurchase: purchase)
        // Add to list
        
        self.didUpdate?()
        self.didChangeOrder?()
    }
    
    func updatePurchase(ofMerch old: Merch, to new: Merch) throws
    {
        // Let trip do the update
        // let purchase = try self.trip.updatePurchase(ofMerch: old, to: new)
        
        // Destroy old presentation
        // Create new presentation; add to list
        // let presentation = self.presentation(forPurchase: purchase)
        
        self.didUpdate?()
        self.didChangeOrder?()        
    }
    
    func merchIsUsed(merch: Merch) -> Bool 
    {
        return self.trip.merchIsUsed(merch)
    }
    
    func deletePurchase(ofMerch merch: Merch) throws
    {
        guard let purchase = self.trip.purchase(ofMerch: merch) else {
            throw MarketListError.ItemNotFound(merch)
        }
        
        try! self.trip.delete(purchase)    // !: Already tested existence
    }
    
    // MARK: - Input
    /** Remove an item */
    func removePurchase(atIndex index: Int)
    {
        // Find appropriate Purchase; remove presentation
        let presentation = self.purchasePresentations.removeAtIndex(index)
        presentation.willDelete { purchase in
            do {
                try self.trip.delete(purchase)
            }
            catch _ {
                fatalError("Attempt to delete nonexistent purchase \(purchase)")
            }
        }
        // Notify up the line
        self.didUpdate?()
        self.didChangeOrder?()
    }
    
    /** Remove all checked-off `Purchase`s. */
    func clearChecked()
    {
        self.purchasePresentations
                .filter { $0.isCheckedOff }
                .forEach { presentation in
                    presentation.willDelete { purchase in 
                        do {
                            try self.trip.delete(purchase)
                        }
                        catch _ {
                            fatalError("Attempt to delete nonexistent purchase \(purchase)")
                        }
                    }
                }
                
        self.didUpdate?()
        self.didChangeOrder?()
        //TODO: Need a didClear?
    }
    
    //Should this return an existing presentation if available?
    private func presentation(forPurchase purchase: Purchase) 
           -> PurchasePresentation 
    {
        let presentation = PurchasePresentation(purchase: purchase)
        // Wire up events
        presentation.didUpdate = { [weak self] (presentation) in
            self?.didUpdate?() 
        }       
        presentation.valueDidChange = { [weak self] (old, new) in
            self?.trip.update(old, to: new)
            self?.purchaseDidChange?(old, new)
            self?.didUpdate?()
        }       
        presentation.didToggleChecked = { [weak self] (_) in 
            self?.didUpdate?()
            self?.didChangeOrder?()
        }
        return presentation
    }
}

