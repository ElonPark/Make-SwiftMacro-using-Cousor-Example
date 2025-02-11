@attached(peer)
public macro CodableKey(_ key: String) = #externalMacro(
    module: "CustomCodableMacros",
    type: "CodableKeyMacro"
) 