/**
 * A type that can be serialized and deserialized by `Encoder` and `Decoder`.
 *
 * Implementers must store and retrieve their essential properties by calling
 * the appropriate "encode" and "decode" methods on the provided coder.
 *
 * This protocol can be used as an adapter layer for `NSCoding`.
 */
protocol Codable
{
    init?(decoder: Decoder)
    func encode(withEncoder encoder: Encoder)
}
