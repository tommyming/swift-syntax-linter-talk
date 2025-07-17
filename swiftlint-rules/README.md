# SwiftLint Rules Package

This package demonstrates **Use Case 2**: Creating SwiftLint-compatible rules using Swift Syntax that can be integrated into the SwiftLint ecosystem.

## Features

- **SwiftLint Integration**: Rules conform to SwiftLint's `Rule` protocol
- **Swift Syntax Powered**: Uses Swift Syntax 600.0.0 for precise AST analysis
- **Configuration Support**: Compatible with `.swiftlint.yml` format
- **Plugin Architecture**: Designed for SwiftLint plugin integration
- **Comprehensive Testing**: Full test suite with SwiftLint patterns

## Available Rules

### swift_syntax_large_class

Detects classes that exceed a specified line count threshold using Swift Syntax.

- **Default threshold**: 200 lines
- **Configurable**: Yes, via `.swiftlint.yml`
- **Kind**: Metrics
- **Severity**: Warning (configurable)

### swift_syntax_too_many_parameters

Identifies functions and initializers with excessive parameter counts using Swift Syntax.

- **Default threshold**: 5 parameters
- **Configurable**: Yes, via `.swiftlint.yml`
- **Kind**: Metrics  
- **Severity**: Warning (configurable)

## Installation

### As a SwiftLint Plugin (Conceptual)

Add this package as a dependency in your project and register the rules:

```swift
import SwiftLintRules

// Register all custom rules
SwiftSyntaxRuleRegistry.registerAllRules()
```

### Configuration

Add the following to your `.swiftlint.yml` file:

```yaml
# Enable custom SwiftSyntax rules
opt_in_rules:
  - swift_syntax_large_class
  - swift_syntax_too_many_parameters

# Configure rule thresholds
swift_syntax_large_class:
  max_lines: 150
  severity: warning

swift_syntax_too_many_parameters:
  max_parameters: 4
  severity: error
```

## Usage

### Building the Package

```bash
swift build
```

### Running Tests

```bash
swift test
```

### Generating Configuration Template

```swift
import SwiftLintRules

let configTemplate = SwiftSyntaxRuleRegistry.generateConfigurationTemplate()
print(configTemplate)
```

## Architecture Comparison

This package demonstrates the **SwiftLint integration approach** vs the standalone approach:

| Feature | Standalone Linter | SwiftLint Rules |
|---------|-------------------|-----------------|
| Integration | None (standalone) | SwiftLint ecosystem |
| Configuration | Custom format | `.swiftlint.yml` |
| Rule Protocol | Custom `LintRule` | SwiftLint's `Rule` |
| Testing | Custom test framework | SwiftLint test helpers |
| Distribution | Executable binary | SwiftLint plugin |
| Ecosystem | Independent | Part of SwiftLint |

## Key Differences from Standalone

1. **Rule Protocol**: Uses SwiftLint's `Rule` and `SwiftSyntaxRule` protocols
2. **Configuration**: Integrates with SwiftLint's configuration system
3. **Testing**: Uses SwiftLint's test helpers and `SwiftLintTestCase`
4. **Distribution**: Designed as SwiftLint plugins rather than standalone tools
5. **Ecosystem**: Benefits from SwiftLint's existing tooling and infrastructure

## Example Rule Implementation

```swift
import SwiftSyntax
import SwiftLintCore
import SwiftLintFramework

public struct MyCustomRule: SwiftSyntaxRule, ConfigurationProviderRule {
    public var configuration = Configuration()
    
    public static let description = RuleDescription(
        identifier: "my_custom_rule",
        name: "My Custom Rule",
        description: "Description of what this rule checks",
        kind: .style
    )
    
    public func makeVisitor(file: SwiftLintFile) -> ViolationsSyntaxVisitor<ConfigurationProviderRule> {
        MyCustomVisitor(configuration: configuration, file: file)
    }
}

private final class MyCustomVisitor: ViolationsSyntaxVisitor<ConfigurationProviderRule> {
    override func visitPost(_ node: SomeSyntaxNode) {
        // Custom logic here
        if shouldTriggerViolation(node) {
            let violation = ReasonedRuleViolation(
                position: node.startLocation(converter: locationConverter),
                reason: "Custom violation message"
            )
            violations.append(violation)
        }
    }
}
```

## Dependencies

- **SwiftLint**: For rule infrastructure and testing
- **Swift Syntax**: For AST parsing and traversal
- **Swift 6.0+**: Required toolchain version

## Contributing

1. Add new rules in `Sources/SwiftLintRules/`
2. Register rules in `SwiftSyntaxRuleRegistry`
3. Add tests in `Tests/SwiftLintRulesTests/`
4. Update configuration template
5. Document rule behavior and configuration options

## Troubleshooting

### Build Issues

- Ensure SwiftLint dependency is available
- Verify Swift 6.0+ is installed
- Check that all SwiftLint imports are correct

### Plugin Integration

- Follow SwiftLint's plugin guidelines
- Ensure proper rule registration
- Test with actual SwiftLint configuration

## See Also

- [SwiftLint Documentation](https://github.com/realm/SwiftLint)
- [Swift Syntax Documentation](https://github.com/apple/swift-syntax)
- [Standalone Linter Example](../standalone-linter/) - Comparison implementation
