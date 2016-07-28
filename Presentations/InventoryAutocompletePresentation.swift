/** A representation of an `Inventory` for purposes of Quick Entry. */
class InventoryAutocompletePresentation
{
    private let inventory: Inventory
    
    init(inventory: Inventory)
    {
        self.inventory = inventory
    }
    
    func suggestedMerchInfo(forTerm prefix: String) -> [MerchInfo] 
    {
        return self.inventory.merch(forTerm: prefix).map { MerchInfo($0) }
    }
}