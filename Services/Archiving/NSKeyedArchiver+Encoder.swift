import class Foundation.NSKeyedArchiver
import class Foundation.NSMutableData

extension NSKeyedArchiver : Encoder
{    
    func encode(codable codable: Encodable, forKey key: String)
    {
        let object = codable as? AnyObject
        self.encodeObject(object, forKey: key)
    } 
    
    func encode(unsignedInt uint: UInt, forKey key: String)
    {
        self.encodeInteger(Int(uint), forKey: key)
    }  
    
    func encode(string string: String, forKey key: String)
    {
        self.encodeObject(string, forKey: key)
    }
    
    func encode(date date: NSDate, forKey key: String)
    {
        self.encodeObject(date, forKey: key)
    }
}