/** 
 * `MarketRepository` is the root of the model serialization system. It
 * translates between `Market` and `MarketData`. It works with an 
 * `Encoder` and a `Decoder` to write and retrieve the data to and from an 
 * archive of some kind. 
 */
class MarketRepository
{
    typealias Key = Market.UniqueID
    
    /** An `Encoder` that the repository can use to write to an archive. */
    var encoder: Encoder?
    /** A `Decoder` that the repository can use to read from an archive. */
    var decoder: Decoder?
    
    init(encoder: Encoder)
    {
        self.encoder = encoder
    }
    
    init(decoder: Decoder)
    {
        self.decoder = decoder
    }
    
    /**
     * Write the given `Market` into `encoder`'s archive. 
     *
     * - Throws: `MarketRepositoryError.Encoder` if no encoder has
     * been provided.
     *
     * - Returns: The `Key` under which the `Market` was stored.
     */
    func write(market: Market) throws -> Key 
    {
        let data = MarketData(market)
        guard let encoder = self.encoder else {
            throw MarketRepositoryError.Encoder
        }
        
        encoder.encode(codable: data, forKey: market.ident)
        
        return market.ident
    }
    
    /**
     * Read the `Market` in `decoder`'s archive for the given `Key`.
     *
     * - Throws:
     *    `MarketRepositoryError.NoDecoder` if no archiver has
     * been provided.
     *
     *    `MarketRepositoryError.KeyNotPresent` if the key does not exist in 
     * the archive. The key is associated to the error.
     *
     * - Returns: A `Market`, or `nil` if the data cannot compose a `Market`.
     */
    func readMarket(forKey key: Key) throws -> Market?
    {
        guard let decoder = self.decoder else {
            throw MarketRepositoryError.NoDecoder
        }
        
        guard let data = decoder.decodeCodable(forKey: key) else {
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
    /** The repository has been asked to write but has no encoder. */
    case Encoder
    /** The repository has been asked to read but has no decoder. */
    case NoDecoder
    /** The associated key was not found for reading inside the archive. */
    case KeyNotPresent(MarketRepository.Key)
}
