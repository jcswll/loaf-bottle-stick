@testable import LoafBottleStickKit

/** 
 * Mock encoder base class for testing; stores data in a dictionary, knows 
 * expected keys.
 */
class MockEncoder : Encoder
{
    // Subclasses must create a list of the expected keys.
    var expectedKeys: [String] { return [] }
    // Collect actual keys received to detect duplicate encodes
    var actualKeys: [String] = []
    // Collect all key-value pairs
    var info: [String : AnyObject] = [:]
    
    var fullyEncoded: Bool { 
        return self.expectedKeys.sort() == self.actualKeys.sort()
    }
   
    func encode(codable codable: AnyObject, forKey key: String)
    {
        self.info[key] = codable
        self.actualKeys.append(key)
    }
    
    func encode(unsignedInt uint: UInt, forKey key: String)  
    {
        self.info[key] = uint
        self.actualKeys.append(key)  
    }
    
    func encode(string string: String, forKey key: String)
    {
        self.info[key] = string
        self.actualKeys.append(key)
    }
    
    func encode(date date: NSDate, forKey key: String)
    {
        self.info[key] = date
        self.actualKeys.append(key)
    }
    
    func encode(bool bool: Bool, forKey key: String)
    {
        self.info[key] = bool
        self.actualKeys.append(key)
    }
    
    func encode(array array: [AnyObject], forKey key: String)
    {
        self.info[key] = array
        self.actualKeys.append(key)
    }
}