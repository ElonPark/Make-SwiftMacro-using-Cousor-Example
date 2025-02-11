import SwiftSyntax
import SwiftSyntaxBuilder

/// CodingKeys enum을 생성하는 타입
struct CodingKeysGenerator {
  /// 프로퍼티 정보를 기반으로 CodingKeys enum 선언을 생성합니다
  static func generateCodingKeys(from properties: [PropertyInfo]) -> DeclSyntax {
    let enumCases = properties
      .map(\.codingKeyDeclaration)
      .joined(separator: "\n")

    let enumDecl = """
      enum CodingKeys: String, CodingKey {
        \(enumCases)
      }
      """

    return DeclSyntax(stringLiteral: enumDecl)
  }
}
