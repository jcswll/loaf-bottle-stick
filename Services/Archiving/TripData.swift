/**
 * `TripData` represets an archive of some kind of an `Trip`; it exposes the 
 * information that a `Trip` needs to construct itself.
 */
struct TripData
{
    let purchases: Set<Purchase>
}