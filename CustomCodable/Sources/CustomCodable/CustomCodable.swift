// The Swift Programming Language
// https://docs.swift.org/swift-book


@attached(member, names: named(CodingKeys))
public macro CustomCodable() = #externalMacro(
  module: "CustomCodableMacros",
  type: "CustomCodableMacro"
)
