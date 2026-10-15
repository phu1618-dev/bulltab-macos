import Foundation

public struct TestFailure: Error, CustomStringConvertible {
    public let message: String
    public let file: String
    public let line: Int
    
    public var description: String {
        return "❌ [\(file):\(line)] \(message)"
    }
}

public func assertEqual<T: Equatable>(_ actual: T, _ expected: T, _ message: String = "", file: String = #file, line: Int = #line) throws {
    if actual != expected {
        let msg = message.isEmpty ? "Expected \(expected), but got \(actual)" : message
        throw TestFailure(message: msg, file: file, line: line)
    }
}

public func assertTrue(_ condition: Bool, _ message: String = "Condition was false", file: String = #file, line: Int = #line) throws {
    if !condition {
        throw TestFailure(message: message, file: file, line: line)
    }
}

public func assertFalse(_ condition: Bool, _ message: String = "Condition was true", file: String = #file, line: Int = #line) throws {
    if condition {
        throw TestFailure(message: message, file: file, line: line)
    }
}

public final class TestSuiteRunner {
    private var passed = 0
    private var failed = 0
    
    public init() {}
    
    public func runTest(name: String, block: () throws -> Void) {
        print("  🔹 Running: \(name)... ", terminator: "")
        do {
            try block()
            passed += 1
            print("✅ PASSED")
        } catch {
            failed += 1
            print("❌ FAILED")
            print("     \(error)")
        }
    }
    
    public func summarize() -> Bool {
        print("\n==========================================")
        print("📊 Test Summary: \(passed) passed, \(failed) failed")
        print("==========================================")
        return failed == 0
    }
}
