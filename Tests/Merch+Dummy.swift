import Foundation
@testable import LoafBottleStickKit

/** Dummy instances of `Merch` for use in various tests. */
extension Merch
{
    /** List of names to be used for test `Merch` creation. */
    static var dummyNames: [String] = ["Broccoli", "Bananas", "Carrots", 
                                       "Apples", "Quince"]
    /** A single test `Merch` using the first name from `dummyNames`. */
    static var dummy: Merch {
        return Merch(name: self.dummyNames[0],
                     unit: .Head,
                  numUses: 17,
                 // Date of iPhone introduction: Jan 9, 2007, 9:43 AM PST
                 lastUsed: NSDate(timeIntervalSince1970:1168364580))
    }
    
    /** A list of test `Merch`es created with the `dummyNames`. */
    static var dummies: [Merch] {
        return self.dummyNames.map { Merch(name: $0, unit: nil) }
    }
    
    /** A single test `Merch` that is not on the `dummies` list. */
    static var offListDummy: Merch = Merch(name: "Milk", unit: .Gallon)
    
    /** Easy creation for testing */
    init(name: String, unit: Unit, numUses: UInt, lastUsed: NSDate)
    {
        self.name = name
        self.unit = unit
        self.numUses = numUses
        self.lastUsed = lastUsed
    }
}
