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
}