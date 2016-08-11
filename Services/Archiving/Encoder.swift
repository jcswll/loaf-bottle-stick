import class Foundation.NSDate
import class Foundation.NSMutableData

protocol Encoder
{
    init(forWritingWithMutableData: NSMutableData)
    
    func encode(codable codable: AnyObject, forKey key: String)  
    
    func encode(unsignedInt uint: UInt, forKey key: String)  
    
    func encode(string string: String, forKey key: String)
    
    func encode(date date: NSDate, forKey key: String)
    
    func encode(bool bool: Bool, forKey key: String)
    
    func encode(array array: [AnyObject], forKey key: String)
}