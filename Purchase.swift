struct Purchase
{
    let item: Merch
    let note: String?
    let quantity: UInt?
    let isCrossedOff: Bool
}

extension Purchase : Hashable 
{
    var hashValue: Int {
        get {
            return self.item.hashValue
        }
    }
}

extension Purchase : Comparable {}

func <(lhs: Purchase, rhs: Purchase) -> Bool
{
    return lhs.item < rhs.item
}

func ==(lhs: Purchase, rhs: Purchase) -> Bool
{
    return lhs.item == rhs.item
}

//MARK: - Purchase creation
extension Purchase
{
    init(ofItem item: Merch, inQuantity quantity: UInt? = nil)
    {
        self.init(item: item, note: nil, quantity: quantity, isCrossedOff: false)
    }
}

//MARK: - Purchase + note
extension Purchase
{
    private init(byAddingNote note: String, toPurchase other: Purchase)
    {
        self.init(item: other.item, note: note, quantity: other.quantity,
                  isCrossedOff: other.isCrossedOff)
    }
    
    func adding(note note: String) -> Purchase
    {
        return Purchase(byAddingNote: note, toPurchase: self)
    }
}

//MARK:- Purchase + crossing off
extension Purchase
{
    private init(byTogglingCrossedOff purchase: Purchase)
    {
        let isCrossedOff = !purchase.isCrossedOff
        self.init(item: purchase.item, note: purchase.note,
                  quantity: purchase.quantity, isCrossedOff: isCrossedOff)
    }
    
    func crossedOff() -> Purchase
    {
        switch self.isCrossedOff {
            case true:
                return self
            case false:
                return Purchase(byTogglingCrossedOff: self)
        }
    }
    
    func uncrossedOff() -> Purchase
    {
        switch self.isCrossedOff {
            case true:
                return Purchase(byTogglingCrossedOff: self)
            case false:
                return self
        }
    }
}
