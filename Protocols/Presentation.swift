/** Wraps a model object and provides UI-oriented access to its data. */
protocol Presentation 
{
    associatedtype Presented
    var presented: Presented { get }
    
    var oldValues: [Presented] { get }
    
    var didUpdate: (() -> Void)?
    //var didError: ((ErrorType) -> Void)?
    var valueDidChange: ((old: Presented, new: Presented) -> Void)?
    
    func willDelete(@noescape _ deletion: ((Presented) -> Void))
    
    /** Undo stack */
    func saveValue()
    var lastValue: Presented
}
