/** Present a `Purchase` in a way that's consumable in a CLI environment. */
class PurchasePresentation
{
    private var purchase: Purchase
    private var oldPurchases: [Purchase] = []
    
    init(purchase: Purchase)
    {
        self.purchase = purchase
    }
    
    // MARK: - Fields
    /** `Purchase` fields: name, unit string, quantity, note, checked off */
    // TODO: Setting name and unit, with propagation
    var name: String { return self.purchase.name }
    var unitDescription: String 
    { 
        guard let quantity = self.quantity,
              let unit = self.purchase.unit
        else { 
            return "" 
        }
        
        return quantity == 1 ? String(unit) : unit.pluralName()
    }
    
    var note: String? 
    {
        get { return self.purchase.note }
        set(note) 
        { 
            self.saveValue()
            self.purchase = self.purchase.changingNote(to: note)
            self.announceChanges() 
        }
    }
    
    var quantity: UInt?
    { 
        get { return self.purchase.quantity }
        set(quantity) 
        { 
            self.saveValue()
            self.purchase = self.purchase.changingQuantity(to: quantity) 
            self.announceChanges()
        }
    }
    
    var isCheckedOff: Bool { return self.purchase.isCheckedOff }
    func toggleChecked()
    {
        self.saveValue()
        self.purchase = self.isCheckedOff ? self.purchase.unchecking() :
                                            self.purchase.checkingOff()
        self.announceChanges(fromTogglingChecked: true)
    }
    
    // MARK: - Events
    var didUpdate: ((PurchasePresentation) -> Void)?
    var valueDidChange: ((old: Purchase, new: Purchase) -> Void)?
    var didToggleChecked: ((Purchase) -> Void)?
    
    /** Provide access to private `purchase` in a passed-in closure. */
    func willDelete(@noescape deletion: ((Purchase) -> Void))
    {
        deletion(self.purchase)
    }
    
    // MARK: - Internals
    /** Notify view and value observers of value changes. */
    private func announceChanges(fromTogglingChecked toggling: Bool = false)
    {
        self.didUpdate?(self)
        self.valueDidChange?(old: self.lastValue, new: self.purchase)
        if toggling {
            self.didToggleChecked?(self.purchase)
        }
    }
    
    /** Push value onto the undo stack */
    private func saveValue()
    {
        self.oldPurchases.append(self.purchase)
    }
    /** Peek value from the undo stack */
    private var lastValue: Purchase { return self.oldPurchases.last! }
}