import SwiftSyntax

/// Visitor that identifies functions with too many parameters
public class TooManyParametersVisitor: SyntaxVisitor {
    private let maxParameters: Int
    var violations: [LintViolation] = []
    
    public init(maxParameters: Int) {
        self.maxParameters = maxParameters
        super.init(viewMode: .sourceAccurate)
    }
    
    override public func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        let parameterCount = node.signature.parameterClause.parameters.count
        
        if parameterCount > maxParameters {
            let location = node.startLocation(converter: SourceLocationConverter(fileName: "", tree: node.root))
            let functionName = node.name.text
            
            let violation = LintViolation(
                rule: "too_many_parameters",
                message: "Function '\(functionName)' has \(parameterCount) parameters, exceeding the maximum of \(maxParameters)",
                line: location.line,
                column: location.column
            )
            violations.append(violation)
        }
        
        return .visitChildren
    }
    
    override public func visit(_ node: InitializerDeclSyntax) -> SyntaxVisitorContinueKind {
        let parameterCount = node.signature.parameterClause.parameters.count
        
        if parameterCount > maxParameters {
            let location = node.startLocation(converter: SourceLocationConverter(fileName: "", tree: node.root))
            
            let violation = LintViolation(
                rule: "too_many_parameters",
                message: "Initializer has \(parameterCount) parameters, exceeding the maximum of \(maxParameters)",
                line: location.line,
                column: location.column
            )
            violations.append(violation)
        }
        
        return .visitChildren
    }
}
