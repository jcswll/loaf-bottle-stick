import XCTest

/** Fail if the passed expression does not throw an error. */
func assertNoThrow<T>(@autoclosure expression: () throws -> T,
                                    _ message: String = "")
 {
     do {

         _ = try expression()
     }
     catch {

         XCTFail(message)
     }
 }
