import XCTest
@testable import SwiftLintRules

final class SwiftSyntaxLargeClassRuleTests: XCTestCase {
    
    func testLargeClassRule() {
        let rule = SwiftSyntaxLargeClassRule()
        let ruleDescription = SwiftSyntaxLargeClassRule.description
        
        // Test non-triggering examples
        for example in ruleDescription.nonTriggeringExamples {
            let file = SwiftLintFile(contents: example.code)
            let violations = rule.validate(file: file)
            XCTAssertEqual(
                violations.count, 0,
                "Expected no violations for: \(example.code)"
            )
        }
        
        // Test triggering examples with custom threshold
        var customRule = SwiftSyntaxLargeClassRule()
        customRule.configuration.maxLines = 10 // Low threshold for testing
        
        for example in ruleDescription.triggeringExamples {
            let file = SwiftLintFile(contents: example.code)
            let violations = customRule.validate(file: file)
            XCTAssertGreaterThan(
                violations.count, 0,
                "Expected violations for: \(example.code)"
            )
        }
    }
    
    func testCustomConfiguration() {
        var rule = SwiftSyntaxLargeClassRule()
        rule.configuration.maxLines = 10
        rule.configuration.severity = .error
        
        let largeClass = """
        class LargeClass {
            var prop1: String = ""
            var prop2: Int = 0
            var prop3: Double = 0.0
            var prop4: Bool = false
            var prop5: [String] = []
            
            func method1() {
                print("method1")
            }
            
            func method2() {
                print("method2")
            }
            
            func method3() {
                print("method3")
            }
        }
        """
        
        let file = SwiftLintFile(contents: largeClass)
        let violations = rule.validate(file: file)
        
        XCTAssertGreaterThan(violations.count, 0, "Should find violations with custom threshold")
        XCTAssertEqual(violations.first?.severity, .error, "Should respect custom severity")
    }
    
    func testConfigurationDescription() {
        let rule = SwiftSyntaxLargeClassRule()
        XCTAssertTrue(rule.configurationDescription.contains("max_lines"))
        XCTAssertTrue(rule.configurationDescription.contains("200"))
    }
}
