@testable import LoafBottleStickKit

/** 
 * Mock decoder base class for testing; retrieves data from a dictionary,
 * keeps track of requested keys.
 */
class MockDecoder : Decoder
{
    // Collect all keys decoded (including duplicates).
    var decodedKeys: [String] = []
    // Subclasses must create the dictionary with necessary pairs.
    var info: [String : AnyObject] { return [:] }
    
    var fullyDecoded: Bool { 
        return self.decodedKeys.sort() == self.info.keys.sort() 
    }

    func decodeCodable(forKey key: String) -> AnyObject?
    {
        self.decodedKeys.append(key)
        return self.info[key]
    }

    func decodeDate(forKey key: String) -> NSDate?
    {
        self.decodedKeys.append(key)
        return self.info[key] as? NSDate
    }

    func decodeString(forKey key: String) -> String?
    {
        self.decodedKeys.append(key)
        return self.info[key] as? String
    }

    func decodeInt(forKey key: String) -> Int?
    {
        self.decodedKeys.append(key)
        return self.info[key] as? Int
    }

    func decodeUnsignedInt(forKey key: String) -> UInt?
    {
        self.decodedKeys.append(key)
        return self.info[key] as? UInt
    }

    func decodeBool(forKey key: String) -> Bool?
    {
        self.decodedKeys.append(key)
        return self.info[key] as? Bool
    }
    
    func decodeArray(forKey key: String) -> [AnyObject]?
    {
        self.decodedKeys.append(key)
        return self.info[key] as? [AnyObject]
    }
}
