import Foundation
@testable import LoafBottleStickKit

/** Dummy instance of `Merch` for use in various tests. */
extension Merch
{
    static var dummy: Merch {
        return Merch(name: "Broccoli",
                     unit: .Head,
                  numUses: 17,
                 lastUsed: NSDate.distantFuture())
    }
    
    /** Easy creation for testing */
    init(name: String, unit: Unit, numUses: UInt, lastUsed: NSDate)
    {
        self.name = name
        self.unit = unit
        self.numUses = numUses
        self.lastUsed = lastUsed
    }
}