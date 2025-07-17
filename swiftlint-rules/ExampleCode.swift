import Foundation

// Sample Swift code for testing SwiftLint rules with Swift Syntax

// Example 1: Large class that should trigger swift_syntax_large_class rule
class ExampleLargeClass {
    var property1: String = ""
    var property2: Int = 0
    var property3: Double = 0.0
    var property4: Bool = false
    var property5: [String] = []
    var property6: Dictionary<String, Any> = [:]
    var property7: Date = Date()
    var property8: URL?
    var property9: Data?
    var property10: UUID = UUID()
    
    init() {
        setupDefaults()
    }
    
    func setupDefaults() {
        property1 = "default"
        property2 = 42
        property3 = 3.14159
        property4 = true
        property5 = ["item1", "item2", "item3"]
        property6 = ["key1": "value1", "key2": "value2"]
        property7 = Date()
        property8 = URL(string: "https://example.com")
        property9 = Data()
        property10 = UUID()
    }
    
    func processData() {
        print("Processing data...")
        if property4 {
            print("Property4 is true")
        }
        
        for item in property5 {
            print("Item: \(item)")
        }
        
        for (key, value) in property6 {
            print("\(key): \(value)")
        }
    }
    
    func calculateSomething() -> Double {
        return property2 * property3
    }
    
    func validateData() -> Bool {
        return !property1.isEmpty && property2 > 0
    }
    
    func transformData() -> [String: Any] {
        return [
            "string": property1,
            "int": property2,
            "double": property3,
            "bool": property4,
            "array": property5,
            "dict": property6,
            "date": property7,
            "url": property8?.absoluteString ?? "",
            "data": property9?.base64EncodedString() ?? "",
            "uuid": property10.uuidString
        ]
    }
    
    func performComplexOperation() {
        let result = calculateSomething()
        print("Complex operation result: \(result)")
        
        if validateData() {
            let transformed = transformData()
            print("Transformed data: \(transformed)")
        }
    }
    
    deinit {
        print("ExampleLargeClass deallocated")
    }
}

// Example 2: Functions with too many parameters (should trigger swift_syntax_too_many_parameters)
class ExampleParameterClass {
    
    // This function has too many parameters (6 > 5 default limit)
    func functionWithTooManyParameters(param1: String, param2: Int, param3: Double, param4: Bool, param5: [String], param6: Date) -> String {
        return "\(param1), \(param2), \(param3), \(param4), \(param5), \(param6)"
    }
    
    // This initializer also has too many parameters
    init(name: String, age: Int, height: Double, isActive: Bool, tags: [String], createdAt: Date, updatedAt: Date) {
        // Initialization code here
    }
    
    // This function has an acceptable number of parameters
    func acceptableFunction(param1: String, param2: Int, param3: Bool) -> String {
        return "\(param1): \(param2) (\(param3))"
    }
}

// Example 3: A reasonably sized class (should not trigger swift_syntax_large_class)
class SmallExampleClass {
    var name: String
    var value: Int
    
    init(name: String, value: Int) {
        self.name = name
        self.value = value
    }
    
    func description() -> String {
        return "\(name): \(value)"
    }
}
