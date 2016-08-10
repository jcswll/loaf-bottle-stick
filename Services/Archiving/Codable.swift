import class Foundation.NSCoder

protocol Decodable
{
    init?(decoder: Decoder)    
}

protocol Encodable
{
    func encode(withEncoder encoder: Encoder)
}
