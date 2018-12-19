import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(tic_tac_toeTests.allTests),
    ]
}
#endif