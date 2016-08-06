/** Specialization for a "shopping trip" list of `Purchase`s */
extension MarketList where Item.SearchKey == Merch
{
    /** Test whether any current `Purchase` uses the given `Merch`. */
    func merchIsUsed(merch: Merch) -> Bool
    {
        return self.item(forKey: merch) != nil
    }
}
