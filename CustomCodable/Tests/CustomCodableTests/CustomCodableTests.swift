import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(CustomCodableMacros)
import CustomCodableMacros

let testMacros: [String: Macro.Type] = [
  "CustomCodable": CustomCodableMacro.self,
]
#endif

final class CustomCodableTests: XCTestCase {
  func testMacro() throws {
    #if canImport(CustomCodableMacros)
    assertMacroExpansion(
      """
      @CustomCodable
      struct Person {
        let name: String
        @CodableKey("user_age") let age: Int
      }
      """,
      expandedSource: """
        struct Person {
          let name: String
          @CodableKey("user_age") let age: Int

          enum CodingKeys: String, CodingKey {
            case name
            case age = "user_age"
          }
        }
        """,
      macros: testMacros,
      indentationWidth: .spaces(2)
    )
    #else
    throw XCTSkip("macros are only supported when running tests for the host platform")
    #endif
  }
}
