import Foundation
@testable import LoafBottleStickKit

/** Dummy instance of `Merch` for use in various tests. */
extension Merch
{
    static var dummy: Merch {
        return Merch(name: "Broccoli",
                     unit: .Head,
                  numUses: 17,
                 // Date of iPhone introduction: Jan 9, 2007, 9:43 AM PST
                 lastUsed: NSDate(timeIntervalSince1970:1168364580))
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