/** Present a `Market`. */
public class MarketPresentation : NSObject
{
    private var market: Market

    init(market: Market)
    {
        self.market = market
    }

    //MARK: - Fields
    /** Market name */
    public var name: String
    {
        get {
            return self.market.name
        }
        set(name) {

            self.market.name = name
            self.didUpdate?()
        }
    }

    public lazy var inventoryPresentation: InventoryPresentation = {
        return InventoryPresentation(inventory: self.market.inventory)
    }()

    lazy var tripPresentation: TripPresentation = {
        return TripPresentation(trip: self.market.trip)
    }()

    //MARK: - Events
    /** Tell view that new values need to be read. */
    public var didUpdate: (() -> Void)?
}
