/**
 * `InventoryData` represets an archive of some kind of an `Inventory`; it 
 * exposes the information that an `Inventory` needs to construct itself.
 */
struct InventoryData
{
    let merchandise: Set<Merch>
}