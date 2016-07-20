/** 
 * A type that provides its own keys and comparators for sorting when in a
 * collection.
 */
protocol Sortable: Comparable
{
    associatedtype SortKey
    /** 
     * Given a self-defined key, return a comparator that sorts instances of
     * this type by that key.
     */
    static func comparator(forKey key: SortKey) -> (Self, Self) -> Bool
}