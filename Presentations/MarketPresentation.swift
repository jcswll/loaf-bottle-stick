/** Present a `Market`. */
class MarketPresentation
{
    private var market: Market
    
    init(market: Market)
    {
        self.market = market
    }
    
    //MARK: - Fields
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
    
    lazy var inventoryPresentation: InventoryPresentation = {
        return InventoryPresentation(inventory: self.market.inventory)
    }()
    
    lazy var tripPresentation: TripPresentation = {
        return TripPresentation(trip: self.market.trip)
    }()
    
    //MARK: - Events
    /** Tell view that new values need to be read. */
    var didUpdate: (() -> Void)?
}
