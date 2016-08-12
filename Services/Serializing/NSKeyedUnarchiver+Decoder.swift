import class Foundation.NSKeyedUnarchiver

/** Allow `NSKeyedUnarchiver` to be used anywhere a `Decoder` is needed. */
extension NSKeyedUnarchiver : Decoder
{   
    func decodeCodable(forKey key: String) -> AnyObject?
    {
        return self.decodeObjectForKey(key)
    }
    
    func decodeDate(forKey key: String) -> NSDate? 
    {
        return self.decodeObjectForKey(key) as? NSDate
    }
    
    func decodeString(forKey key: String) -> String? 
    {
        return self.decodeObjectForKey(key) as? String
    }
    
    func decodeInt(forKey key: String) -> Int? 
    {
        return self.decodeIntegerForKey(key)
    }
    
    func decodeUnsignedInt(forKey key: String) -> UInt? 
    {
        return UInt(self.decodeIntegerForKey(key))
    }
    
    func decodeBool(forKey key: String) -> Bool? 
    {
        return self.decodeBoolForKey(key)
    }
    
    func decodeArray(forKey key: String) -> [AnyObject]?
    {
        return (self.decodeObjectForKey(key) as? NSArray) as? [AnyObject]
    }
}
