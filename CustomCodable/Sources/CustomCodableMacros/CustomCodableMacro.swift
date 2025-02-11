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
    let properties = PropertyExtractor.extractProperties(from: declaration)
    return [CodingKeysGenerator.generateCodingKeys(from: properties)]
  }
}

@main
struct CustomCodablePlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    CustomCodableMacro.self,
    CodableKeyMacro.self,
  ]
}
