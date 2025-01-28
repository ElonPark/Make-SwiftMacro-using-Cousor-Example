import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct CustomCodableMacro: MemberMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    []
  }
}

@main
struct CustomCodablePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
      CustomCodableMacro.self,
    ]
}
