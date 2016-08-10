import class Foundation.NSKeyedUnarchiver

extension NSKeyedUnarchiver : Decoder
{   
    func decodeEncodable(forKey key: String) -> Decodable?
    {
        return self.decodeObjectForKey(key) as? Decodable
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
}
