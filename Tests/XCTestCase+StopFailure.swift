import XCTest

extension XCTestCase
{
    /** Do not continue after failure of any assertions in the closure. */
    func stopOnFailure(assertions: () -> Void)
    {
        self.continueAfterFailure = false
        // Reset continue status for other tests. Happily, this does run even
        // if `assertions` fails and the test stops.
        defer { self.continueAfterFailure = true }

        assertions()
    }
}