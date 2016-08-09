import class Foundation.NSCoder

/** 
 * `MarketRepository` is the root of the model archving system. It translates
 * between `Market` and `MarketData`. It works with an instance of an 
 * `NSCoder` subclass to write and retrieve the data to an archive of some 
 * kind. 
 */
class MarketRepository
{
    typealias Key = Market.UniqueID
    
    /** An `NSCoder` that the repository can use to write to an archive. */
    var archiver: NSCoder?
    /** An `NSCoder` that the repository can use to read from an archive. */
    var unarchiver: NSCoder?
    
    init(archiver: NSCoder)
    {
        self.archiver = archiver
    }
    
    init(unarchiver: NSCoder)
    {
        self.unarchiver = unarchiver
    }
    
    /**
     * Write the given `Market` into `archiver`'s archive. 
     *
     * - Throws: `MarketRepositoryError.NoArchiver` if no archiver has
     * been provided.
     *
     * - Returns: The `Key` under which the `Market` was stored.
     */
    func write(market: Market) throws -> Key 
    {
        let data = MarketData(market)
        guard let archiver = self.archiver else {
            throw MarketRepositoryError.NoArchiver
        }
        
        archiver.encodeObject(data, forKey: market.ident)
        
        return market.ident
    }
    
    /**
     * Read the `Market` in `unarchiver`'s archive for the given `Key`.
     *
     * - Throws: `MarketRepositoryError.NoUnarchiver` if no archiver has
     * been provided.
     * - Throws: `MarketRepositoryError.KeyNotPresent` if the key does not
     * exist in the archive. The key is associated to the error.
     *
     * - Returns: A `Market`, or `nil` if the data cannot compose a 
     * `Market`.
     */
    func readMarket(forKey key: Key) throws -> Market?
    {
        guard let unarchiver = self.unarchiver else {
            throw MarketRepositoryError.NoUnarchiver
        }
        
        guard let data = unarchiver.decodeObjectForKey(key) else {
            throw MarketRepositoryError.KeyNotPresent(key)
        }

        guard let market = (data as? MarketData)?.market else {
            return nil
        }
        
        return market
    }
}

/** Errors when attempting to read or write archives. */
enum MarketRepositoryError : ErrorType
{
    /** The repository has been asked to write but has no archiver. */
    case NoArchiver
    /** The repository has been asked to read but has no unarchiver. */
    case NoUnarchiver
    /** The associated key was not found for reading inside the archive. */
    case KeyNotPresent(MarketRepository.Key)
}
