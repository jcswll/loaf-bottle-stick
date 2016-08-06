
enum MarketListError<Item: MarketItem> : ErrorType
{   
    /** 
     * Thrown when an `Item` passed in for deletion or updating is not 
     * found in the list. 
     */
    case ItemNotFound(Item)
}