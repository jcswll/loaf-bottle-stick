import XCTest
@testable import LoafBottleStickKit

class MarketRepositoryTests : XCTestCase
{
    func testEncodesAndReturnsKey()
    {
        let archiver = MockArchiver()
        let market = Market(name: "Abbandando's Groceria")
        
        let repo = MarketRepository(encoder: archiver)
        let key = try? repo.write(market)
        
        // Encode method was called
        XCTAssert(archiver.didEncode)
        // Using the market's key
        XCTAssertEqual(market.ident, archiver.key)
        // The returned key exists
        stopOnFailure { XCTAssertNotNil(key) }
        // and matches the original market's
        XCTAssertEqual(market.ident, key!)
    }
    
    func testDecodes()
    {
        let market = Market(name: "Abbandando's Groceria")
        let data = MarketData(market)
        let unarchiver = MockUnarchiver(fromData: data)
        
        let repo = MarketRepository(decoder: unarchiver)
        let decodedMarket = try? repo.readMarket(forKey: market.ident)
        
        // Decode method was called
        XCTAssert(unarchiver.didDecode)
        // Using the market's key
        XCTAssertEqual(market.ident, unarchiver.key)
        // The decoded market exists
        stopOnFailure { XCTAssertNotNil(decodedMarket) }
        // and matches the original
        XCTAssertEqual(decodedMarket!, market)
    }
    
    func testWillNotEncodeWithoutArchiver()
    {
        let market = Market(name: "Abbandando's Groceria")
        let data = MarketData(market)
        let unarchiver = MockUnarchiver(fromData: data)
        
        let repo = MarketRepository(decoder: unarchiver)
        
        XCTAssertThrowsError(try repo.write(market))
    }
    
    func testWillNotDecodeWithoutUnarchiver()
    {
        let market = Market(name: "Abbandando's Groceria")
        let archiver = MockArchiver()
        
        let repo = MarketRepository(encoder: archiver)
        
        XCTAssertThrowsError(try repo.readMarket(forKey: market.ident))
    }
    
    func testCannotDecodeNonexistentKey()
    {
        let market = Market(name: "Abbandando's Groceria")
        let data = MarketData(market)
        let unarchiver = MockUnarchiver(fromData: data)
        
        let repo = MarketRepository(decoder: unarchiver)
        
        XCTAssertThrowsError(try repo.readMarket(forKey: ""))
    }
}

class MockArchiver : MockEncoder 
{
    var didEncode: Bool = false
    var key: MarketRepository.Key? = nil
    
    override func encode(codable codable: AnyObject, forKey key: String) 
    {
        self.didEncode = true
        if let marketData = codable as? MarketData {
            self.key = marketData.ident
        }
    }
}

class MockUnarchiver : MockDecoder
{
    var didDecode: Bool = false
    var key: MarketRepository.Key? = nil
    let data: MarketData
    
    init(fromData data: MarketData)
    {
        self.data = data
        super.init()
    }
    
    required init(forReadingWithData data: NSData) 
    {
        fatalError()
    }
    
    override func decodeEncodable(forKey key: String) -> AnyObject?
    {
        self.didDecode = true
        self.key = key
        return self.data.ident == key ? self.data : nil
    }
}
