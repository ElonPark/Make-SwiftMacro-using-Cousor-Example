import SwiftSyntax
import SwiftSyntaxBuilder

/// 구조체에서 프로퍼티 정보를 추출하는 타입
struct PropertyExtractor {
  /// 구조체 선언에서 모든 프로퍼티 정보를 추출합니다
  static func extractProperties(from declaration: some DeclGroupSyntax) -> [PropertyInfo] {
    guard let structDecl = declaration.as(StructDeclSyntax.self) else {
      return []
    }

    return structDecl.memberBlock.members.compactMap { member in
      extractProperty(from: member.decl)
    }
  }

  /// 개별 선언에서 프로퍼티 정보를 추출합니다
  private static func extractProperty(from declaration: DeclSyntax) -> PropertyInfo? {
    guard let varDecl = declaration.as(VariableDeclSyntax.self),
          let binding = varDecl.bindings.first,
          let identifier = binding.pattern.as(IdentifierPatternSyntax.self)
    else {
      return nil
    }

    let propertyName = identifier.identifier.text
    let customKey = extractCustomKey(from: varDecl.attributes)

    return PropertyInfo(name: propertyName, customKey: customKey)
  }

  /// @CodableKey 어트리뷰트에서 커스텀 키를 추출합니다
  private static func extractCustomKey(from attributes: AttributeListSyntax) -> String? {
    for attribute in attributes {
      guard let attributeType = attribute.as(AttributeSyntax.self),
            attributeType.attributeName.as(IdentifierTypeSyntax.self)?.name.text == "CodableKey",
            let arguments = attributeType.arguments?.as(LabeledExprListSyntax.self),
            let firstArg = arguments.first?.expression.as(StringLiteralExprSyntax.self)
      else {
        continue
      }
      return firstArg.description
    }
    return nil
  }
}