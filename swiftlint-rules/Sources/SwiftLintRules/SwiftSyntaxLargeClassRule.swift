import SwiftSyntax
// import SwiftLintCore
// import SwiftLintFramework

// Using mock SwiftLint infrastructure for demonstration
// In production, replace this with real SwiftLint imports

/// SwiftLint rule that detects classes with too many lines using Swift Syntax
public struct SwiftSyntaxLargeClassRule: SwiftSyntaxRule, ConfigurationProviderRule {
    public var configuration = Configuration()
    
    public static let description = RuleDescription(
        identifier: "swift_syntax_large_class",
        name: "Swift Syntax Large Class",
        description: "Classes should not exceed the maximum line count (implemented with Swift Syntax)",
        kind: .metrics,
        nonTriggeringExamples: [
            Example("""
            class SmallClass {
                var name: String = ""
                
                func getName() -> String {
                    return name
                }
            }
            """),
            Example("""
            class ReasonableSizeClass {
                var property1: String = ""
                var property2: Int = 0
                
                func method1() {
                    print("method1")
                }
                
                func method2() {
                    print("method2")
                }
            }
            """)
        ],
        triggeringExamples: [
            Example("""
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
                
                func method4() {
                    print("method4")
                }
                
                func method5() {
                    print("method5")
                }
            }
            """)
        ]
    )
    
    public var configurationDescription: String {
        return "max_lines: \(configuration.maxLines) (default: 200)"
    }
    
    public init() {}
    
    public func makeVisitor(file: SwiftLintFile) -> LargeClassVisitor {
        return LargeClassVisitor(configuration: configuration, file: file)
    }
    
    public func validate(file: SwiftLintFile) -> [StyleViolation] {
        let visitor = makeVisitor(file: file)
        visitor.walk(file.syntaxTree)
        
        return visitor.violations.map { violation in
            StyleViolation(
                ruleDescription: Self.description,
                severity: configuration.severity,
                location: violation.position,
                reason: violation.reason
            )
        }
    }
}

public final class LargeClassVisitor: ViolationsSyntaxVisitor<SwiftSyntaxLargeClassRule.Configuration> {
    public override func visitPost(_ node: ClassDeclSyntax) {
        let startLocation = node.startLocation(converter: locationConverter)
        let endLocation = node.endLocation(converter: locationConverter)
        
        let lineCount = endLocation.line - startLocation.line + 1
        let maxLines = configuration.maxLines
        
        if lineCount > maxLines {
            let violation = ReasonedRuleViolation(
                position: startLocation,
                reason: "Class '\(node.name.text)' has \(lineCount) lines, exceeding the maximum of \(maxLines) lines"
            )
            violations.append(violation)
        }
    }
}

// MARK: - Configuration

extension SwiftSyntaxLargeClassRule {
    public struct Configuration: RuleConfiguration {
        public var severityConfiguration = SeverityConfiguration<SwiftSyntaxLargeClassRule>(.warning)
        public var maxLines: Int = 200
        
        public var severity: ViolationSeverity {
            get { severityConfiguration.severity }
            set { severityConfiguration.severity = newValue }
        }
        
        public init(maxLines: Int = 200) {
            self.maxLines = maxLines
        }
        
        public mutating func apply(configuration: Any) throws {
            guard let configuration = configuration as? [String: Any] else {
                throw ConfigurationError.unknownConfiguration
            }
            
            if let maxLines = configuration["max_lines"] as? Int {
                self.maxLines = maxLines
            }
            
            if let severityString = configuration["severity"] as? String {
                try severityConfiguration.apply(configuration: severityString)
            }
        }
    }
}
