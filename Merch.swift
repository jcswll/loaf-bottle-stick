import Foundation

struct Merch
{
    let name: String
    let unit: Unit
    let numPurchases: UInt
    let lastUsed: NSDate = NSDate()
    
    enum MerchSortKey
    {
        case Name, Date, Count
    }
}

extension Merch : Hashable 
{
    var hashValue: Int { get { return self.name.hashValue } }
}

func ==(lhs: Merch, rhs: Merch) -> Bool
{
    return lhs.name == rhs.name
}

extension Merch : Comparable
{
    static func comparator(forKey key: MerchSortKey) -> (Merch, Merch) -> Bool
    {
        switch key {
            case .Name:
                return compareByName
            case .Date:
                return compareByDate
            case .Count:
                return compareByCount
        }
    }
    
    static func compareByName(lhs: Merch to rhs: Merch) -> Bool
    {
        return lhs < rhs
    }
    
    static func compareByDate(lhs: Merch to rhs: Merch) -> Bool
    {
        return lhs.lastUsed < rhs.lastUsed
    }
    
    static func compareByCount(lhs: Merch to rhs: Merch) -> Bool
    {
        return lhs.numPurchases < rhs.numPurchases
    }    
}

func <(lhs: Merch, rhs: Merch) -> Bool
{
    return lhs.name < rhs.name
}

//MARK:- Merch creation
extension Merch
{   
    init(named name: String)
    {
        self.init(named: name, inUnit: .Each)
    }
    
    init(named name: String, inUnit unit: Unit)
    {
        self.name = name
        self.unit = unit
        self.numPurchases = 1
    }
}

//MARK: Merch + purchasing
extension Merch
{
    private init(byPurchasing other: Merch)
    {
        self.name = other.name
        self.unit = other.unit
        self.numPurchases = other.numPurchases + 1
    }
    
    func purchased() -> Merch
    {
        return Merch(byPurchasing: self)
    }
}

extension Merch
{
    private init(fromOther other: Merch, changingUnitTo unit: Unit)
    {
        self.name = other.name
        self.unit = unit
        self.numPurchases = other.numPurchases
    }
    
    func changing(unit unit: Unit)
    {
        return Merch(fromOther: self, changingUnitTo: unit)
    }
}
