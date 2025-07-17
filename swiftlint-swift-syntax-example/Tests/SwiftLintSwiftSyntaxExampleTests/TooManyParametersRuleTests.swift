import SwiftSyntax
import SwiftParser
@testable import SwiftLintSwiftSyntaxExample

final class TooManyParametersRuleTests {
    
    func testFunctionWithTooManyParameters() {
        let source = """
        func exampleFunction(param1: String, param2: Int, param3: Double, param4: Bool, param5: [String], param6: Date) {
            print("Too many parameters")
        }
        """
        
        let tree = Parser.parse(source: source)
        let rule = TooManyParametersRule(maxParameters: 4)
        let violations = rule.check(tree)
        
        assert(violations.count == 1)
        assert(violations.first?.rule == "too_many_parameters")
        assert(violations.first?.message.contains("exampleFunction") ?? false)
        print("✅ testFunctionWithTooManyParameters passed")
    }
    
    func testInitializerWithTooManyParameters() {
        let source = """
        class ExampleClass {
            init(param1: String, param2: Int, param3: Double, param4: Bool, param5: [String], param6: Date) {
                // Initialization
            }
        }
        """
        
        let tree = Parser.parse(source: source)
        let rule = TooManyParametersRule(maxParameters: 4)
        let violations = rule.check(tree)
        
        assert(violations.count == 1)
        assert(violations.first?.rule == "too_many_parameters")
        assert(violations.first?.message.contains("Initializer") ?? false)
        print("✅ testInitializerWithTooManyParameters passed")
    }
    
    func testFunctionWithAcceptableParameters() {
        let source = """
        func acceptableFunction(param1: String, param2: Int, param3: Bool) {
            print("Acceptable parameters")
        }
        """
        
        let tree = Parser.parse(source: source)
        let rule = TooManyParametersRule(maxParameters: 4)
        let violations = rule.check(tree)
        
        assert(violations.count == 0)
        print("✅ testFunctionWithAcceptableParameters passed")
    }
    
    static func runAllTests() {
        let tests = TooManyParametersRuleTests()
        tests.testFunctionWithTooManyParameters()
        tests.testInitializerWithTooManyParameters()
        tests.testFunctionWithAcceptableParameters()
        print("✅ All TooManyParametersRule tests passed!")
    }
}
