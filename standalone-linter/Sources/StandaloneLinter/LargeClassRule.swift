import SwiftSyntax

/// Rule that detects classes with too many lines
public class LargeClassRule: LintRule {
    public let name = "large_class"
    public let description = "Classes should not exceed the maximum line count"
    
    private let maxLines: Int
    
    public init(maxLines: Int = 200) {
        self.maxLines = maxLines
    }
    
    public func check(_ tree: SourceFileSyntax) -> [LintViolation] {
        let visitor = LargeClassVisitor(maxLines: maxLines)
        visitor.walk(tree)
        return visitor.violations
    }
}

/// Visitor that identifies large classes
private class LargeClassVisitor: SyntaxVisitor {
    private let maxLines: Int
    var violations: [LintViolation] = []
    
    init(maxLines: Int) {
        self.maxLines = maxLines
        super.init(viewMode: .sourceAccurate)
    }
    
    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        let startLocation = node.startLocation(converter: SourceLocationConverter(fileName: "", tree: node.root))
        let endLocation = node.endLocation(converter: SourceLocationConverter(fileName: "", tree: node.root))
        
        let lineCount = endLocation.line - startLocation.line + 1
        
        if lineCount > maxLines {
            let className = node.name.text
            let violation = LintViolation(
                rule: "large_class",
                message: "Class '\(className)' has \(lineCount) lines, exceeding the maximum of \(maxLines) lines",
                line: startLocation.line,
                column: startLocation.column
            )
            violations.append(violation)
        }
        
        return .visitChildren
    }
}
