extension Array
{
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
