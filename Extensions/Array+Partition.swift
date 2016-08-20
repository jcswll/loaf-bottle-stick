extension Array
{
    /**
     * Divide an array in two by testing each element with a predicate.
     *
     * - Returns: A tuple of arrays. The first array contains all the elements
     * for which the predicate returned `true`, the second all those that
     * evaluated as `false`.
     *
     * - Remarks: The original array is processed in order, and the relative
     * orders of the items in the subarrays will not change.
     */
    func partition(@noescape test: (Element) -> Bool)
        -> ([Element], [Element])
    {
        return self.reduce((Array<Element>(), Array<Element>())){

            (reduction: ([Element], [Element]), next: Element) in

                var (first, second) = reduction

                if test(next) {
                    first.append(next)
                }
                else {
                    second.append(next)
                }

                return (first, second)
        }
    }
}
