/**
 * Presents a sorted list of `PurchasePresentation`s for use by a table view.
 *
 * When changes are made, the view and other observers are notified via
 * callback closures.
 */
class TripPresentation
{
    private var trip: MarketList<Purchase>

    init(trip: MarketList<Purchase>)
    {
        self.trip = trip
        self.sortKey = .Name
        self.separateCheckedItems = false
        self.subPresentations = trip.items.map {
                                    self.presentation(forPurchase: $0)
                                }.sort { (lhs, rhs) in
                                    lhs.compare(to: rhs, byKey: self.sortKey)
                                }
    }

    //MARK: - Fields
    var sortKey: Purchase.SortKey {
         didSet {
            self.sortSubpresentations()
            self.didUpdate?()
         }
    }

    /**
     * Checked-off items can be sorted to the bottom; the two sub-lists
     * will order themselves according to `sortKey`.
     */
    var separateCheckedItems: Bool {
        didSet {
            self.sortSubpresentations()
            self.didUpdate?()
        }
    }

    // IUO to allow construction in init while referring to self
    private(set) var subPresentations: [PurchasePresentation]!

    //MARK: - Events
    /** Tell view that new values need to be read. */
    var didUpdate: (() -> Void)?
    /** Notify parent of deletion, passing new trip and deleted item. */
    var didDeletePurchase: ((MarketList<Purchase>, Purchase) -> Void)?
    /** Notify observer of change in a contained `Purchase`. */
    var purchaseDidChange: ((Purchase, Purchase) -> Void)?
    /** Notify observer of change to a `Merch` in a contained `Purchase`. */
    var merchDidChange: ((Merch, Merch) -> Void)?

    //MARK: - Input
    /** Propagates `MarketListError.ItemExists(purchase)` */
    func add(purchase: Purchase) throws
    {
        try self.trip.add(purchase)

        let presentation = self.presentation(forPurchase: purchase)
        self.subPresentations.append(presentation)
        self.sortSubpresentations()
        self.didUpdate?()
    }

    /** Remove the purchase and sub-presentation at the given index. */
    func deletePurchase(atIndex index: Int)
    {
        guard index < self.subPresentations.count else {
            fatalError("Attempt to delete presentation at index \(index) " +
                       "outside valid range 0-\(self.subPresentations.count)")
        }
        let presentation = self.subPresentations.removeAtIndex(index)

        presentation.willDelete { (purchase) in

            do {

                try self.trip.delete(purchase)
            }
            catch {

                fatalError("Attempt to delete non-existent " +
                           "Purchase\n\(purchase)")
            }

            self.didDeletePurchase?(self.trip, purchase)
        }
        self.didUpdate?()
    }

    //MARK: - Internals
    /**
     * Construct a `PurchasePresentation` for the given purchase, wiring its
     * notification closures up as needed.
     */
    private func presentation(forPurchase purchase: Purchase)
                -> PurchasePresentation
    {
        let presentation = PurchasePresentation(purchase: purchase)
        presentation.valueDidChange = {
            [weak self] (old, new) in
                self?.update(old, to: new)
        }
        presentation.merchDidChange = {
            [weak self] (old, new) in
                self?.merchDidChange?(old, new)
        }

        return presentation
    }

    /**
     * Update `trip` with the new value, sort if needed, and notify.
     */
    private func update(item: Purchase, to replacement: Purchase)
    {
        do {

            try self.trip.update(item, to: replacement)
        }
        catch {

            fatalError("Attempt to update non-existent Merch\n\(item)")
        }

        let changedKey = self.changedKey(from: item, to: replacement)
        if changedKey == self.sortKey {
            self.sortSubpresentations()
        }

        self.purchaseDidChange?(item, replacement)
        self.didUpdate?()
    }

    /** Re-sort `subPresentations` after a change. */
    private func sortSubpresentations()
    {
        if self.separateCheckedItems {
            self.sortSubpresentationsSeparated()
        }
        else {

            self.subPresentations.sortInPlace {
                (lhs, rhs) in
                    lhs.compare(to: rhs, byKey: self.sortKey)
            }
        }
    }

    /**
     * Split the sub-presentations by their checked off state, then sort
     * the two pieces and rejoin them.
     */
    private func sortSubpresentationsSeparated()
    {
        let (checked, unchecked) = self.subPresentations
                                       .partition { $0.isCheckedOff }
        let comparator = {

            (lhs: PurchasePresentation, rhs: PurchasePresentation) -> Bool in
                lhs.compare(to: rhs, byKey: self.sortKey)
        }

        self.subPresentations = unchecked.sort(comparator) +
                                checked.sort(comparator)
    }

    /**
     * Figure out which field of the `Purchase` changed so we don't have to
     * re-sort unnecessarily.
     */
    private func changedKey(from from: Purchase, to: Purchase)
                -> Purchase.SortKey?
    {
        return from.name != to.name ? .Name : nil
    }
}
