extension Set
{
    typealias FilterPredicate = (Element) throws -> Bool
    func firstElement(@noescape test: FilterPredicate) rethrows 
                   -> Element?
    {
        return try self.filter(test).first
    }
}
