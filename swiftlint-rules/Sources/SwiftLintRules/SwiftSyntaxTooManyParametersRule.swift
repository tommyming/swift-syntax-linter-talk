import SwiftSyntax
// import SwiftLintCore
// import SwiftLintFramework

/// SwiftLint rule that detects functions with too many parameters using Swift Syntax
public struct SwiftSyntaxTooManyParametersRule: SwiftSyntaxRule, ConfigurationProviderRule {
    public var configuration = Configuration()
    
    public static let description = RuleDescription(
        identifier: "swift_syntax_too_many_parameters",
        name: "Swift Syntax Too Many Parameters",
        description: "Functions should not have too many parameters (implemented with Swift Syntax)",
        kind: .metrics,
        nonTriggeringExamples: [
            Example("""
            func acceptableFunction(param1: String, param2: Int, param3: Bool) {
                print("Acceptable parameters")
            }
            """),
            Example("""
            init(name: String, age: Int) {
                // Initialization
            }
            """),
            Example("""
            func functionWithFourParams(p1: String, p2: Int, p3: Bool, p4: Double) {
                // Still acceptable with default threshold of 5
            }
            """)
        ],
        triggeringExamples: [
            Example("""
            func functionWithTooManyParameters(param1: String, param2: Int, param3: Double, param4: Bool, param5: [String], param6: Date) {
                print("Too many parameters")
            }
            """),
            Example("""
            init(param1: String, param2: Int, param3: Double, param4: Bool, param5: [String], param6: Date) {
                // Initialization
            }
            """)
        ]
    )
    
    public var configurationDescription: String {
        return "max_parameters: \(configuration.maxParameters) (default: 5)"
    }
    
    public init() {}
    
    public func makeVisitor(file: SwiftLintFile) -> TooManyParametersVisitor {
        return TooManyParametersVisitor(configuration: configuration, file: file)
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

public final class TooManyParametersVisitor: ViolationsSyntaxVisitor<SwiftSyntaxTooManyParametersRule.Configuration> {
    public override func visitPost(_ node: FunctionDeclSyntax) {
        let parameterCount = node.signature.parameterClause.parameters.count
        let maxParameters = configuration.maxParameters
        
        if parameterCount > maxParameters {
            let functionName = node.name.text
            let violation = ReasonedRuleViolation(
                position: node.startLocation(converter: locationConverter),
                reason: "Function '\(functionName)' has \(parameterCount) parameters, exceeding the maximum of \(maxParameters)"
            )
            violations.append(violation)
        }
    }
    
    public override func visitPost(_ node: InitializerDeclSyntax) {
        let parameterCount = node.signature.parameterClause.parameters.count
        let maxParameters = configuration.maxParameters
        
        if parameterCount > maxParameters {
            let violation = ReasonedRuleViolation(
                position: node.startLocation(converter: locationConverter),
                reason: "Initializer has \(parameterCount) parameters, exceeding the maximum of \(maxParameters)"
            )
            violations.append(violation)
        }
    }
}

// MARK: - Configuration

extension SwiftSyntaxTooManyParametersRule {
    public struct Configuration: RuleConfiguration {
        public var severityConfiguration = SeverityConfiguration<SwiftSyntaxTooManyParametersRule>(.warning)
        public var maxParameters: Int = 5
        
        public var severity: ViolationSeverity {
            get { severityConfiguration.severity }
            set { severityConfiguration.severity = newValue }
        }
        
        public init(maxParameters: Int = 5) {
            self.maxParameters = maxParameters
        }
        
        public mutating func apply(configuration: Any) throws {
            guard let configuration = configuration as? [String: Any] else {
                throw ConfigurationError.unknownConfiguration
            }
            
            if let maxParameters = configuration["max_parameters"] as? Int {
                self.maxParameters = maxParameters
            }
            
            if let severityString = configuration["severity"] as? String {
                try severityConfiguration.apply(configuration: severityString)
            }
        }
    }
}
