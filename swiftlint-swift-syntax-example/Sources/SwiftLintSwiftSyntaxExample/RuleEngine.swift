import SwiftSyntax

/// Protocol that all lint rules must conform to
public protocol LintRule {
    /// The name identifier for this rule
    var name: String { get }
    
    /// A human-readable description of what this rule checks
    var description: String { get }
    
    /// Check a syntax tree and return any violations found
    func check(_ tree: SourceFileSyntax) -> [LintViolation]
}

/// Represents a violation of a lint rule
public struct LintViolation {
    /// The rule that was violated
    public let rule: String
    
    /// Description of the violation
    public let message: String
    
    /// Line number where the violation occurred
    public let line: Int
    
    /// Column number where the violation occurred
    public let column: Int
    
    /// The file path where the violation occurred
    public let file: String?
    
    public init(rule: String, message: String, line: Int, column: Int, file: String? = nil) {
        self.rule = rule
        self.message = message
        self.line = line
        self.column = column
        self.file = file
    }
}

/// Engine that coordinates running multiple lint rules
public class RuleEngine {
    private var rules: [LintRule] = []
    
    public init() {}
    
    /// Register a rule with the engine
    public func addRule(_ rule: LintRule) {
        rules.append(rule)
    }
    
    /// Run all registered rules against a syntax tree
    public func lint(_ tree: SourceFileSyntax, file: String? = nil) -> [LintViolation] {
        var violations: [LintViolation] = []
        
        for rule in rules {
            let ruleViolations = rule.check(tree).map { violation in
                LintViolation(
                    rule: violation.rule,
                    message: violation.message,
                    line: violation.line,
                    column: violation.column,
                    file: file ?? violation.file
                )
            }
            violations.append(contentsOf: ruleViolations)
        }
        
        return violations
    }
    
    /// Get all registered rules
    public var registeredRules: [LintRule] {
        return rules
    }
}
