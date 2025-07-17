import SwiftSyntax
import SwiftParser

// MARK: - Mock SwiftLint Protocols and Types
// These demonstrate the SwiftLint integration patterns without requiring the full SwiftLint dependency

/// Mock SwiftLint Rule protocol (simplified version)
public protocol Rule {
    static var description: RuleDescription { get }
    var configurationDescription: String { get }
    
    func validate(file: SwiftLintFile) -> [StyleViolation]
}

/// Mock SwiftSyntax-based rule protocol
public protocol SwiftSyntaxRule: Rule {
    associatedtype Visitor: ViolationsSyntaxVisitor<Configuration>
    associatedtype Configuration: RuleConfiguration
    
    func makeVisitor(file: SwiftLintFile) -> Visitor
}

/// Mock configuration provider protocol
public protocol ConfigurationProviderRule: Rule {
    associatedtype Configuration: RuleConfiguration
    var configuration: Configuration { get set }
}

/// Mock rule description
public struct RuleDescription: Sendable {
    public let identifier: String
    public let name: String
    public let description: String
    public let kind: RuleKind
    public let nonTriggeringExamples: [Example]
    public let triggeringExamples: [Example]
    
    public init(
        identifier: String,
        name: String,
        description: String,
        kind: RuleKind,
        nonTriggeringExamples: [Example] = [],
        triggeringExamples: [Example] = []
    ) {
        self.identifier = identifier
        self.name = name
        self.description = description
        self.kind = kind
        self.nonTriggeringExamples = nonTriggeringExamples
        self.triggeringExamples = triggeringExamples
    }
}

/// Mock rule kind
public enum RuleKind: Sendable {
    case lint
    case idiomatic
    case style
    case metrics
    case performance
}

/// Mock example
public struct Example: Sendable {
    public let code: String
    
    public init(_ code: String) {
        self.code = code
    }
}

/// Mock violation severity
public enum ViolationSeverity: String, Sendable {
    case warning = "warning"
    case error = "error"
}

/// Mock style violation
public struct StyleViolation {
    public let ruleDescription: RuleDescription
    public let severity: ViolationSeverity
    public let location: SourceLocation
    public let reason: String?
    
    public init(
        ruleDescription: RuleDescription,
        severity: ViolationSeverity,
        location: SourceLocation,
        reason: String? = nil
    ) {
        self.ruleDescription = ruleDescription
        self.severity = severity
        self.location = location
        self.reason = reason
    }
}

/// Mock reasoned rule violation
public struct ReasonedRuleViolation {
    public let position: SourceLocation
    public let reason: String
    
    public init(position: SourceLocation, reason: String) {
        self.position = position
        self.reason = reason
    }
}

/// Mock SwiftLint file
public class SwiftLintFile {
    public let contents: String
    public let syntaxTree: SourceFileSyntax
    
    public init(contents: String) {
        self.contents = contents
        self.syntaxTree = Parser.parse(source: contents)
    }
    
    public var locationConverter: SourceLocationConverter {
        return SourceLocationConverter(fileName: "", tree: syntaxTree)
    }
}

/// Mock violations syntax visitor
open class ViolationsSyntaxVisitor<T>: SyntaxVisitor {
    public var violations: [ReasonedRuleViolation] = []
    public let locationConverter: SourceLocationConverter
    public let configuration: T
    
    public init(configuration: T, file: SwiftLintFile) {
        self.configuration = configuration
        self.locationConverter = file.locationConverter
        super.init(viewMode: .sourceAccurate)
    }
}

/// Mock rule configuration protocol
public protocol RuleConfiguration {
    var severity: ViolationSeverity { get set }
    mutating func apply(configuration: Any) throws
}

/// Mock severity configuration
public struct SeverityConfiguration<T>: RuleConfiguration {
    public var severity: ViolationSeverity
    
    public init(_ severity: ViolationSeverity) {
        self.severity = severity
    }
    
    public mutating func apply(configuration: Any) throws {
        if let severityString = configuration as? String {
            if let newSeverity = ViolationSeverity(rawValue: severityString) {
                self.severity = newSeverity
            }
        }
    }
}

/// Mock configuration error
public enum ConfigurationError: Error {
    case unknownConfiguration
}
