# Standalone Linter Package

This package demonstrates **Use Case 1**: Building a complete linting framework from scratch using Swift Syntax, without dependencies on external linting frameworks.

## Features

- **Custom Rule Framework**: Independent `LintRule` protocol and `RuleEngine`
- **Swift Syntax Integration**: Uses Swift Syntax 600.0.0 for AST parsing  
- **Command-line Tool**: `StandaloneLintAnalyzer` executable
- **Configurable Rules**: Customizable thresholds for all rules
- **No External Dependencies**: Only depends on Swift Syntax

## Rules Included

### Large Class Rule
- **Purpose**: Detects classes exceeding line count thresholds
- **Default Threshold**: 200 lines
- **Configuration**: `LargeClassRule(maxLines: 150)`

### Too Many Parameters Rule  
- **Purpose**: Identifies functions with excessive parameters
- **Default Threshold**: 5 parameters
- **Configuration**: `TooManyParametersRule(maxParameters: 3)`

## Features

- Built with Swift Syntax for accurate AST parsing
- Extensible rule system
- Command-line analyzer tool
- Comprehensive test suite

## Usage

### Building the Project

```bash
swift build
```

### Running the Analyzer

```bash
# Build the project first
swift build

# Run the analyzer on a Swift file
./.build/debug/SwiftLintAnalyzer <path-to-swift-file>

# Example: Analyze the included example code
./.build/debug/SwiftLintAnalyzer ExampleCode.swift
```

### Running Tests

```bash
swift test
```

## Project Structure

- `Sources/SwiftLintSwiftSyntaxExample/` - Core linting rules and engine
- `Sources/SwiftLintAnalyzer/` - Command-line analyzer tool
- `Tests/` - Unit tests for the linting rules
- `ExampleCode.swift` - Sample Swift code to test rules against

## Creating Custom Rules

To create a new rule:

1. Implement the `LintRule` protocol
2. Create a visitor class that inherits from `SyntaxVisitor`
3. Register the rule with the `RuleEngine`
4. Add tests for your rule

## Dependencies

- Swift Syntax 600.0.0+
- Swift 6.0+

## Example Output

When running the analyzer on the included `ExampleCode.swift`, you'll see output like:

```bash
❌ Found 2 violation(s) in ExampleCode.swift:

[Too_Many_Parameters] Function 'functionWithTooManyParameters' has 6 parameters, exceeding the maximum of 5
  at ExampleCode.swift:92:5

[Too_Many_Parameters] Initializer has 7 parameters, exceeding the maximum of 5
  at ExampleCode.swift:97:5
```

## Rule Configuration

### Large Class Rule

- **Default threshold**: 200 lines
- **Configurable**: `LargeClassRule(maxLines: 150)` for custom threshold

### Too Many Parameters Rule

- **Default threshold**: 5 parameters
- **Configurable**: `TooManyParametersRule(maxParameters: 3)` for custom threshold

## Troubleshooting

### Build Issues

If you encounter build issues:

1. **Clean the build directory**: `rm -rf .build`
2. **Ensure Swift 6.0+ is installed**: `swift --version`
3. **Update dependencies**: The project uses Swift Syntax 600.0.0+

### No Output from Analyzer

If the analyzer runs but produces no output:

1. Check that the file path is correct
2. Ensure the Swift file contains code that would trigger the rules
3. Verify rules are registered in `main.swift`

## Contributing

To add new rules:

1. Create a new rule class implementing `LintRule`
2. Create a corresponding visitor class if needed
3. Add the rule to the engine in `main.swift`
4. Write tests for your rule
5. Update this README with rule documentation
