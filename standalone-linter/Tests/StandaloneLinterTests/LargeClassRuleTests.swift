import SwiftSyntax
import SwiftParser
@testable import StandaloneLinter

final class LargeClassRuleTests {
    
    func testLargeClassDetection() {
        let source = """
        class LargeClass {
            var prop1: String = ""
            var prop2: Int = 0
            var prop3: Double = 0.0
            var prop4: Bool = false
            var prop5: [String] = []
            
            func method1() {
                print("method1")
            }
            
            func method2() {
                print("method2")
            }
            
            func method3() {
                print("method3")
            }
            
            func method4() {
                print("method4")
            }
            
            func method5() {
                print("method5")
            }
        }
        """
        
        let tree = Parser.parse(source: source)
        let rule = LargeClassRule(maxLines: 10) // Set a low threshold for testing
        let violations = rule.check(tree)
        
        assert(violations.count == 1)
        assert(violations.first?.rule == "large_class")
        assert(violations.first?.message.lowercased().contains("largeclass") == true)
        print("✅ testLargeClassDetection passed")
    }
    
    func testSmallClassNotDetected() {
        let source = """
        class SmallClass {
            var name: String = ""
            
            func getName() -> String {
                return name
            }
        }
        """
        
        let tree = Parser.parse(source: source)
        let rule = LargeClassRule(maxLines: 10)
        let violations = rule.check(tree)
        
        assert(violations.count == 0)
        print("✅ testSmallClassNotDetected passed")
    }
    
    func testMultipleClassesDetection() {
        let source = """
        class SmallClass1 {
            var prop: String = ""
        }
        
        class LargeClass {
            var prop1: String = ""
            var prop2: Int = 0
            var prop3: Double = 0.0
            var prop4: Bool = false
            var prop5: [String] = []
            
            func method1() { print("1") }
            func method2() { print("2") }
            func method3() { print("3") }
            func method4() { print("4") }
            func method5() { print("5") }
        }
        
        class SmallClass2 {
            var prop: Int = 0
        }
        """
        
        let tree = Parser.parse(source: source)
        let rule = LargeClassRule(maxLines: 10)
        let violations = rule.check(tree)
        
        assert(violations.count == 1)
        assert(violations.first?.message.lowercased().contains("largeclass") == true)
        print("✅ testMultipleClassesDetection passed")
    }
    
    static func runAllTests() {
        let tests = LargeClassRuleTests()
        tests.testLargeClassDetection()
        tests.testSmallClassNotDetected()
        tests.testMultipleClassesDetection()
        print("✅ All LargeClassRule tests passed!")
    }
}
