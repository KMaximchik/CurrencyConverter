// MARK: - Currency

public struct Currency {
    public let symbol: String
    public let name: String
    public let symbolNative: String
    public let decimalDigits: Int
    public let rounding: Int
    public let code: CurrencyCode
    public let namePlural: String

    public init(
        symbol: String,
        name: String,
        symbolNative: String,
        decimalDigits: Int,
        rounding: Int,
        code: CurrencyCode,
        namePlural: String
    ) {
        self.symbol = symbol
        self.name = name
        self.symbolNative = symbolNative
        self.decimalDigits = decimalDigits
        self.rounding = rounding
        self.code = code
        self.namePlural = namePlural
    }
}
