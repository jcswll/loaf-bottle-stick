/**
 * A `Purchase` represents an entry on a shopping list, consisting of a `Merch`,
 * the state of being crossed off or not, and an optional quantity and note.
 */
struct Purchase
{
    let merch: Merch
    var note: String?
    var quantity: UInt?
    private(set) var isCrossedOff: Bool
    
    init(ofMerch merch: Merch, inQuantity quantity: UInt?)
    {
        self.merch = merch
        self.note = ""
        self.quantity = quantity
        self.isCrossedOff = false
    }
    
    mutating func crossOff()
    {
        self.isCrossedOff = true
    }
    
    mutating func uncross()
    {
        self.isCrossedOff = false
    }
}

extension Purchase : Hashable
{
    var hashValue: Int { return self.merch.hashValue }
}

extension Purchase : Comparable {}

func ==(lhs: Purchase, rhs: Purchase) -> Bool
{
    return lhs.merch == rhs.merch
}

func <(lhs: Purchase, rhs: Purchase) -> Bool
{
    return lhs.merch < rhs.merch
}
