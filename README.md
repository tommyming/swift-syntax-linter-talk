# Swift Syntax Linter Talk

This repository contains examples and demonstrations of creating custom linting rules using Apple's Swift Syntax library.

## Projects

### swiftlint-swift-syntax-example

A complete example project demonstrating:

- **Custom Lint Rules**: Large Class Rule and Too Many Parameters Rule
- **Rule Engine**: Framework for running multiple rules
- **Command-line Tool**: SwiftLintAnalyzer executable
- **Testing**: Comprehensive test suite
- **Swift 6.0 Support**: Updated for latest Swift toolchain

#### Quick Start

```bash
cd swiftlint-swift-syntax-example
swift build
./.build/debug/SwiftLintAnalyzer ExampleCode.swift
```

## Features Demonstrated

- ✅ Swift Syntax AST parsing and traversal
- ✅ Custom SyntaxVisitor implementations  
- ✅ Violation reporting with line/column information
- ✅ Configurable rule thresholds
- ✅ Extensible rule engine architecture
- ✅ Command-line interface
- ✅ Unit testing for lint rules

## Requirements

- Swift 6.0+
- Swift Syntax 600.0.0+
- macOS 12+ / iOS 13+ / tvOS 13+ / watchOS 6+

See individual project READMEs for detailed setup and usage instructions.
