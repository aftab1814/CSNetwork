import Foundation

public extension Double {
    private static var valueFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.roundingMode = .down
        return formatter
    }()
    
    func formatWithDecimal(upto decimalPlaces: Int) -> String? {
        let number = NSNumber(value: self)
        Self.valueFormatter.maximumFractionDigits = decimalPlaces
        return Self.valueFormatter.string(from: number)
    }
}
