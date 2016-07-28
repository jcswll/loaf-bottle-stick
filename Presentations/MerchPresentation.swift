
typealias PermissionCallback = ((Bool) -> Void)

/** Present a `Merch` in a way that's consumable in a CLI environment. */
class MerchPresentation
{
    private var merch: Merch
    private var oldMerch: [Merch] = []
    
    init(merch: Merch)
    {
        self.merch = merch
    }
    
    //MARK: - `Merch` fields
    var name: String 
    { 
        get { return self.merch.name }
        set(name) 
        {   
            self.saveValue()
            self.merch = self.merch.changingName(to: name)
            self.announceChanges() 
        }
    } 
    
    var unitName: String { return self.merch.unit.rawValue }
    
    // Not using setter of `unit` because its type is `String`
    func setUnit(unit: Unit)
    {
        self.saveValue()
        self.merch = self.merch.changingUnit(to: unit)
        self.announceChanges()
    }
    
    /** Figure out whether the merch is already used in a Purchase. */
    var isInPurchase: ((Merch) -> Bool) = { _ in false }

    // MARK: - Data events
    /** Tell view that new values should be read. */
    var didUpdate: (() -> Void)?
    /** Pass value changes out to an observer. */
    var valueDidChange: ((old: Merch, new: Merch) -> Void)?
    /** Ask whether the purchase should take place. */
    var shouldPurchase: ((Merch, PermissionCallback) -> Void)?
    /** Pass purchased merch out to an observer. */
    var didPurchase: ((Merch, UInt?) -> Void)?
    
    /** Provide access to private `merch` in a passed-in closure. */
    func willDelete(@noescape deletion: ((Merch) -> Void))
    {
        deletion(self.merch)
    }
    
    // MARK: - Input
    func purchase()
    {
        self.shouldPurchase?(self.merch) { permission in
            guard permission else { return }
            self.saveValue()
            self.merch = self.merch.purchasing()
            self.announceChanges(fromPurchasing: true)
        }
    }
    
    // MARK: - Internals
    /** Notify view and value observers of value changes. */
    private func announceChanges(fromPurchasing fromPurchasing: Bool = false)
    {
        self.didUpdate?()
        self.valueDidChange?(old: self.lastValue, new: self.merch)
        if fromPurchasing {
            //FIXME: Get actual quantity
            self.didPurchase?(self.merch, 0)
        }
    }
    
    /** Push value onto the undo stack */
    private func saveValue()
    {
        self.oldMerch.append(self.merch)
    }
    /** Peek value from the undo stack */
    private var lastValue: Merch { return self.oldMerch.last! }
}
