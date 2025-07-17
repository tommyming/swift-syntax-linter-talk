import XCTest
@testable import SwiftLintRules

final class SwiftSyntaxTooManyParametersRuleTests: XCTestCase {
    
    func testTooManyParametersRule() {
        let rule = SwiftSyntaxTooManyParametersRule()
        let ruleDescription = SwiftSyntaxTooManyParametersRule.description
        
        // Test non-triggering examples
        for example in ruleDescription.nonTriggeringExamples {
            let file = SwiftLintFile(contents: example.code)
            let violations = rule.validate(file: file)
            XCTAssertEqual(
                violations.count, 0,
                "Expected no violations for: \(example.code)"
            )
        }
        
        // Test triggering examples
        for example in ruleDescription.triggeringExamples {
            let file = SwiftLintFile(contents: example.code)
            let violations = rule.validate(file: file)
            XCTAssertGreaterThan(
                violations.count, 0,
                "Expected violations for: \(example.code)"
            )
        }
    }
    
    func testCustomParameterThreshold() {
        let customThresholdFunction = """
        func functionWithThreeParams(p1: String, p2: Int, p3: Bool) {
            print("Three parameters")
        }
        """
        
        // Should not trigger with default threshold of 5
        let defaultRule = SwiftSyntaxTooManyParametersRule()
        let file1 = SwiftLintFile(contents: customThresholdFunction)
        let violations1 = defaultRule.validate(file: file1)
        XCTAssertEqual(
            violations1.count, 0,
            "Should not trigger with default threshold"
        )
        
        // Should trigger with custom threshold of 2
        var customRule = SwiftSyntaxTooManyParametersRule()
        customRule.configuration.maxParameters = 2
        let file2 = SwiftLintFile(contents: customThresholdFunction)
        let violations2 = customRule.validate(file: file2)
        XCTAssertGreaterThan(
            violations2.count, 0,
            "Should trigger with custom threshold of 2"
        )
    }
    
    func testInitializerDetection() {
        let initWithManyParams = """
        class TestClass {
            init(p1: String, p2: Int, p3: Double, p4: Bool, p5: [String], p6: Date) {
                // Too many parameters
            }
        }
        """
        
        let rule = SwiftSyntaxTooManyParametersRule()
        let file = SwiftLintFile(contents: initWithManyParams)
        let violations = rule.validate(file: file)
        
        XCTAssertGreaterThan(violations.count, 0, "Should detect initializers with too many parameters")
        XCTAssertTrue(
            violations.first?.reason?.contains("Initializer") ?? false,
            "Violation message should mention initializer"
        )
    }
    
    func testConfigurationDescription() {
        let rule = SwiftSyntaxTooManyParametersRule()
        XCTAssertTrue(rule.configurationDescription.contains("max_parameters"))
        XCTAssertTrue(rule.configurationDescription.contains("5"))
    }
}
