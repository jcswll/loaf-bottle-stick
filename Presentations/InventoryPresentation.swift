/**
 * Presents a sorted list of `MerchPresentation`s for use by a table view.
 *
 * When changes are made, the view and other observers are notified via
 * callback closures.
 */
class InventoryPresentation
{
    private var inventory: MarketList<Merch>

    init(inventory: MarketList<Merch>)
    {
        self.inventory = inventory
        self.sortKey = .Name
        self.subPresentations = inventory.items.map {
                                    self.presentation(forMerch: $0)
                                }.sort { (lhs, rhs) in
                                    lhs.compare(to: rhs, byKey: self.sortKey)
                                }
    }

    //MARK: - Fields
    var sortKey: Merch.SortKey
    {
        didSet {

            self.sortSubpresentations()
            self.didUpdate?()
        }
    }

    var subPresentations: [MerchPresentation]!

    //MARK: - Events
    /** Tell view that new values need to be read. */
    var didUpdate: (() -> Void)?
    /** Notify parent of deletion, passing new inventory and deleted item. */
    var didDeleteMerch: ((MarketList<Merch>, Merch) -> Void)?
    /** Notify observer of change in a contained Merch. */
    var merchDidChange: ((Merch, Merch) -> Void)?
    /** Complete purchase, passing updated Merch. */
    var makePurchase: ((Merch, UInt) -> Void)?

    //MARK: - Input
    /** Propagates MarketListError.ItemExists(merch) */
    func add(merch: Merch) throws
    {
        try self.inventory.add(merch)

        self.subPresentations.append(self.presentation(forMerch: merch))
        self.sortSubpresentations()
        self.didUpdate?()
    }

    /** Remove the merch and sub-presentation at the given index. */
    func deleteMerch(atIndex index: Int)
    {
        guard index < self.subPresentations.count else {
            fatalError("Attempt to delete presentation at index \(index) " +
                       "outside valid range 0-\(self.subPresentations.count)")
        }
        let presentation = self.subPresentations.removeAtIndex(index)

        presentation.willDelete { (merch) in

            do {

                try self.inventory.delete(merch)
            }
            catch {

                fatalError("Attempt to delete non-existent Merch\n\(merch)")
            }

            self.didDeleteMerch?(self.inventory, merch)
        }
        self.didUpdate?()
    }

    //MARK: - Internals
    /**
     * Construct a `MerchPresentation` for the given merch, wiring its
     * notification closures up as needed.
     */
    private func presentation(forMerch merch: Merch) -> MerchPresentation
    {
        let presentation = MerchPresentation(merch: merch)

        presentation.valueDidChange = {
            [weak self] (old, new) in
                self?.update(old, to: new)
        }

        presentation.didPurchase = {
            [weak self] (merch, quantity) in
                self?.makePurchase?(merch, quantity)
        }

        return presentation
    }

    /**
     * Update `inventory` with the new value, sort if needed, and notify.
     */
    private func update(item: Merch, to replacement: Merch)
    {
        do {

            try self.inventory.update(item, to: replacement)
        }
        catch {

            fatalError("Attempt to update non-existent Merch\n\(item)")
        }

        if self.changedKey(from: item, to: replacement) == self.sortKey {
            self.sortSubpresentations()
        }

        self.merchDidChange?(item, replacement)
        self.didUpdate?()
    }

    /** Re-sort `subPresentations` after a change. */
    private func sortSubpresentations()
    {
        self.subPresentations.sortInPlace {
            (lhs, rhs) in
                lhs.compare(to: rhs, byKey: self.sortKey)
        }
    }

    /**
     * Figure out which field of the `Merch` changed so we don't have to
     * re-sort unnecessarily.
     */
    private func changedKey(from from: Merch, to: Merch) -> Merch.SortKey?
    {
        if from.name != to.name {
            return .Name
        }
        if from.lastUsed != to.lastUsed {
            return .Date
        }
        if from.numUses != to.numUses {
            return .Uses
        }
        return nil
    }
}
