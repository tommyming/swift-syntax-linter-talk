# Swift Syntax Linter Talk

This repository demonstrates **two different approaches** to creating custom linting rules using Apple's Swift Syntax library.

> [!WARNING]
> This repository is still under active development and drafting stage, use it with caution.

## Projects

### 1. standalone-linter

**Use Case 1**: Building a complete linting framework from scratch

- **Custom Rule Framework**: Independent rule system with `LintRule` protocol
- **Standalone Architecture**: No external linting framework dependencies  
- **Command-line Tool**: `StandaloneLintAnalyzer` executable
- **Testing**: Custom test framework
- **Distribution**: Standalone binary

#### Standalone Quick Start

```bash
cd standalone-linter
swift build
./.build/debug/StandaloneLintAnalyzer ExampleCode.swift
```

### 2. swiftlint-rules

**Use Case 2**: Creating SwiftLint-compatible rules with Swift Syntax

- **SwiftLint Integration**: Rules that conform to SwiftLint's `Rule` protocol
- **Plugin Architecture**: Designed as SwiftLint plugins
- **Configuration**: Uses `.swiftlint.yml` format
- **Testing**: SwiftLint test helpers and framework
- **Distribution**: SwiftLint plugins

#### SwiftLint Integration Quick Start

```bash
cd swiftlint-rules
swift build
swift test
```

## Architecture Comparison

| Feature | Standalone Linter | SwiftLint Rules |
|---------|-------------------|-----------------|
| **Dependencies** | Swift Syntax only | SwiftLint + Swift Syntax |
| **Rule Protocol** | Custom `LintRule` | SwiftLint's `Rule` |
| **Configuration** | Custom format | `.swiftlint.yml` |
| **Testing** | Custom framework | SwiftLint test helpers |
| **Distribution** | Standalone binary | SwiftLint plugin |
| **Integration** | Independent tool | Part of SwiftLint ecosystem |
| **Flexibility** | Complete control | SwiftLint constraints |
| **Maintenance** | Self-contained | Depends on SwiftLint updates |

## Features Demonstrated

- ✅ Swift Syntax AST parsing and traversal
- ✅ Custom SyntaxVisitor implementations  
- ✅ Violation reporting with line/column information
- ✅ Configurable rule thresholds
- ✅ Extensible rule engine architecture
- ✅ Command-line interface (standalone)
- ✅ SwiftLint plugin architecture (SwiftLint rules)
- ✅ Unit testing for lint rules
- ✅ Both standalone and integrated approaches

## Requirements

- Swift 6.0+
- Swift Syntax 600.0.0+
- macOS 12+ / iOS 13+ / tvOS 13+ / watchOS 6+
- SwiftLint 0.57.0+ (for swiftlint-rules package)

## Use Cases

**Choose Standalone Linter when:**

- You need complete control over the linting process
- You want to integrate with custom build systems
- You're building a specialized linting tool
- You don't want SwiftLint dependencies

**Choose SwiftLint Rules when:**

- You already use SwiftLint in your project
- You want to leverage SwiftLint's ecosystem
- You need standard SwiftLint configuration and reporting
- You want to distribute rules as plugins

See individual project READMEs for detailed setup and usage instructions.
