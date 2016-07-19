extension SequenceType
{
    public typealias FilterPredicate = (Generator.Element) throws -> Bool
    /** 
     * Return the first element that passes the predicate. The meaning of
     * "first" is determined by the sequence's own ordering.
     */
    public func firstElement(@noescape passing test: FilterPredicate) rethrows 
        -> Generator.Element?
    {
        return try self.filter(test).first
    }
}
