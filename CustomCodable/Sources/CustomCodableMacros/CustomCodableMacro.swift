import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct CodableKeyMacro: PeerMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingPeersOf declaration: some DeclSyntaxProtocol,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    []
  }
}

public struct CustomCodableMacro: MemberMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    // 구조체의 모든 프로퍼티를 가져옵니다
    guard let structDecl = declaration.as(StructDeclSyntax.self) else {
      return []
    }

    var codingKeys: [(name: String, customKey: String?)] = []

    // 모든 멤버를 순회하면서 프로퍼티를 찾습니다
    for member in structDecl.memberBlock.members {
      guard let varDecl = member.decl.as(VariableDeclSyntax.self) else { continue }
      guard let binding = varDecl.bindings.first else { continue }
      guard let identifier = binding.pattern.as(IdentifierPatternSyntax.self) else { continue }

      let propertyName = identifier.identifier.text
      var customKey: String? = nil

      // @CodableKey 속성이 있는지 확인합니다
      for attribute in varDecl.attributes {
        guard let attributeType = attribute.as(AttributeSyntax.self) else { continue }
        guard attributeType.attributeName.as(IdentifierTypeSyntax.self)?.name.text == "CodableKey"
        else { continue }

        if let arguments = attributeType.arguments?.as(LabeledExprListSyntax.self),
           let firstArg = arguments.first?.expression.as(StringLiteralExprSyntax.self) {
          // 문자열 리터럴에서 따옴표를 포함하여 가져옵니다
          customKey = firstArg.description
        }
      }

      codingKeys.append((name: propertyName, customKey: customKey))
    }

    // CodingKeys enum을 생성합니다
    let enumCases = codingKeys.map { key in
      if let customKey = key.customKey {
        return "case \(key.name) = \(customKey)"
      } else {
        return "case \(key.name)"
      }
    }.joined(separator: "\n")

    let enumDecl = """
      enum CodingKeys: String, CodingKey {
        \(enumCases)
      }
      """

    return [DeclSyntax(stringLiteral: enumDecl)]
  }
}

@main
struct CustomCodablePlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    CustomCodableMacro.self,
    CodableKeyMacro.self,
  ]
}
