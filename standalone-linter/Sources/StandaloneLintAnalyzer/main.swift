import Foundation
import SwiftSyntax
import SwiftParser
import StandaloneLinter

struct StandaloneLintAnalyzer {
    static func main() {
        let arguments = CommandLine.arguments
        
        guard arguments.count > 1 else {
            print("Usage: StandaloneLintAnalyzer <file.swift>")
            exit(1)
        }
        
        let filePath = arguments[1]
        
        guard let sourceCode = try? String(contentsOfFile: filePath) else {
            print("Error: Could not read file at \(filePath)")
            exit(1)
        }
        
        let sourceFile = Parser.parse(source: sourceCode)
        let engine = RuleEngine()
        
        // Register rules
        engine.addRule(LargeClassRule())
        engine.addRule(TooManyParametersRule())
        
        let violations = engine.lint(sourceFile)
        
        if violations.isEmpty {
            print("✅ No violations found in \(filePath)")
        } else {
            print("❌ Found \(violations.count) violation(s) in \(filePath):")
            print()
            for violation in violations {
                print("[\(violation.rule.capitalized)] \(violation.message)")
                print("  at \(filePath):\(violation.line):\(violation.column)")
                print()
            }
        }
    }
}

StandaloneLintAnalyzer.main()
