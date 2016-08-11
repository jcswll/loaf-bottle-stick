import class Foundation.NSKeyedArchiver
import class Foundation.NSMutableData

extension NSKeyedArchiver : Encoder
{    
    func encode(codable codable: AnyObject, forKey key: String)
    {
        self.encodeObject(codable, forKey: key)
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
    
    func encode(bool bool: Bool, forKey key: String)
    {
        self.encodeBool(bool, forKey: key)
    }
    
    func encode(array array: [AnyObject], forKey key: String)
    {
        self.encodeObject(array, forKey: key)
    }
}