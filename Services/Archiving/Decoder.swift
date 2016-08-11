import class Foundation.NSData
import class Foundation.NSDate

protocol Decoder : class
{
    init(forReadingWithData data: NSData)
    
    func decodeEncodable(forKey key: String) -> AnyObject?
    
    func decodeDate(forKey key: String) -> NSDate?
    
    func decodeString(forKey key: String) -> String?
    
    func decodeInt(forKey key: String) -> Int?
    
    func decodeUnsignedInt(forKey key: String) -> UInt?
    
    func decodeBool(forKey key: String) -> Bool?
    
    func decodeArray(forKey key: String) -> [AnyObject]?
}
