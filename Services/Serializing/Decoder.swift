import class Foundation.NSDate

/** 
 * A type that deserializes data from an archive of some kind.
 *
 * This is an adapter layer for `NSCoder`'s "decode" functionality, providing
 * more type information.
 */
protocol Decoder : class
{    
    func decodeCodable(forKey key: String) -> AnyObject?
    
    func decodeDate(forKey key: String) -> NSDate?
    
    func decodeString(forKey key: String) -> String?
    
    func decodeInt(forKey key: String) -> Int?
    
    func decodeUnsignedInt(forKey key: String) -> UInt?
    
    func decodeBool(forKey key: String) -> Bool?
    
    func decodeArray(forKey key: String) -> [AnyObject]?
}
