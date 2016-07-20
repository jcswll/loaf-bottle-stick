/** Wraps a model object and provides UI-oriented access to its data. */
protocol Presentation 
{
    associatedtype Presented
    
    var parent: Presentation?
    var presented: Presented { get }
}