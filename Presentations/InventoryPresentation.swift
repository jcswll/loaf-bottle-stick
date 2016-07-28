/** Present an `Inventory` in a way that's consumable in a CLI environment. */
class InventoryPresentation
{
    private var inventory: Inventory
    
    init(inventory: Inventory)
    {
        self.inventory = inventory
        self.sortKey = .Name
    }
    
    // MARK: - Fields
    /** Sorted list of `Presentation`s for inventory's items */
    var sortKey: Merch.SortKey { didSet{ self.didChangeOrder?() } }
    //FIXME: Ignoring sort for the moment.
    var merchPresentations: [MerchPresentation] = []
    
    // MARK: - Events
    /** Tell view that new values should be read. */
    var didUpdate: (() -> Void)?
    //FIXME: Are these two redundant?
    /** Tell view that full list needs to be read. */
    var didChangeOrder: (() -> Void)?
    /** Ask about purchase, allowing cancellation. */
    var shouldPurchase: ((Merch, PermissionCallback) -> Void)?
    /** Complete purchase, passing updated Merch. */
    var makePurchase: ((Merch, UInt?) -> Void)?
    /** Notify observer of change in a contained Merch. */
    var merchDidChange: ((Merch, Merch) -> Void)?
    /** Figure out whether the Merch is already used in a Purchase. */
    var merchIsInPurchase: ((Merch) -> Bool)?
    /** Notify of Merch deletion. */
    var didDeleteMerch: ((Merch) -> Void)?
    /** Notify of Merch creation */
    var didCreateMerch: ((Merch) -> Void)?
    /** Get information to create new Merch */
    typealias InfoCallback = ((MerchInfo) -> Void)
    var shouldCreate: ((InfoCallback) -> Void)?
    
    func load()
    {
        self.merchPresentations = self.inventory.items.map { 
                        self.presentation(forMerch: $0) 
        }
    }

    
    // MARK: - Input
    /** Remove an item */
    func deleteMerch(atIndex index: Int)
    {
        // Find appropriate Merch; remove presentation
        let presentation = self.merchPresentations.removeAtIndex(index)
        // Tell inventory to remove it
        presentation.willDelete { merch in
            do { 
                try self.inventory.delete(merch) 
            }
            catch _ {
                fatalError("Attempt to delete nonexistent Merch \(merch.name)")
            }
            // Notify up the line
            self.didDeleteMerch?(merch)
        }
        self.didChangeOrder?()
    }
    
    /** Add an item */
    func createMerch()
    {
        // FIXME: Handle purchasing existing Merch
        
        // Propose purchase with callback
        self.shouldCreate? { (info) in
            let (name, unit) = (info.name, info.unit)
            // Get info, tell inventory to create Merch
            let merch = self.inventory.createMerch(named: name, inUnit: unit)
            // Create presentation for new Merch, insert
            let presentation = self.presentation(forMerch: merch)
            // self.merchPresentations.append(presentation)
            // Tell presentation to purchase, **but don't pass request up**
            presentation.shouldPurchase = { (_, callback) in callback(true) }
            presentation.purchase() // FIXME: Don't ignore quantity
            // Restore purchase permission chain
            //FIXME: Revisit this: should be a better way. At least factor out this closure from here and presentation(forMerch:)
            presentation.shouldPurchase = { [weak self] (merch, callback) in
                self?.shouldPurchase?(merch, callback)
            }
            // Notify of changes
            self.didCreateMerch?(merch)
            self.didChangeOrder?()
        }
    }   
    
    // MARK: -
    private func presentation(forMerch merch: Merch) -> MerchPresentation
    {
        let presentation = MerchPresentation(merch: merch)
        presentation.shouldPurchase = { [weak self] (merch, callback) in
            self?.shouldPurchase?(merch, callback)
        }
        
        presentation.didPurchase = { [weak self] (merch, quantity) in
            self?.makePurchase?(merch, quantity)
            return
        }
        
        presentation.valueDidChange = { [weak self] (old, new) in
            // Need self.didUpdate?() here?
            self?.inventory.update(old, to: new)
            self?.merchDidChange?(old, new)
        }
        
        presentation.isInPurchase = { [weak self] (merch) in
            guard let answer = self?.merchIsInPurchase?(merch) else {
                return false
            }
            return answer
        }
        return presentation
    }
}
