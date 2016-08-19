import class Foundation.NSDate

/**
 * A type that serializes data into an archive of some kind.
 *
 * This is an adapter layer for `NSCoder`'s "encode" functionality, providing
 * more type information.
 */
protocol Encoder
{
    func encode(codable codable: AnyObject, forKey key: String)

    func encode(unsignedInt uint: UInt, forKey key: String)

    func encode(string string: String, forKey key: String)

    func encode(date date: NSDate, forKey key: String)

    func encode(bool bool: Bool, forKey key: String)

    func encode(array array: [AnyObject], forKey key: String)
}
