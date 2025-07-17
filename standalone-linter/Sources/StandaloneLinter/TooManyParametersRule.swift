import SwiftSyntax

/// Rule that detects functions with too many parameters
public class TooManyParametersRule: LintRule {
    public let name = "too_many_parameters"
    public let description = "Functions should not have too many parameters"
    
    private let maxParameters: Int
    
    public init(maxParameters: Int = 5) {
        self.maxParameters = maxParameters
    }
    
    public func check(_ tree: SourceFileSyntax) -> [LintViolation] {
        let visitor = TooManyParametersVisitor(maxParameters: maxParameters)
        visitor.walk(tree)
        return visitor.violations
    }
}
