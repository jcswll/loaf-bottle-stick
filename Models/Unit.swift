/** `Unit` represents a real-world unit of measurement. */
public enum Unit : String
{   
    // Weight: U.S./Imperial
    case Ton, Pound, Ounce
    // Weight: Metric
    case Kilogram, Gram, Milligram
    // Fluid volume: U.S./Imperial
    case Gallon, Quart, Pint, Cup, Tablespoon, Teaspoon
    // Fluid volume: Metric
    case Liter, Milliliter
    // Length: U.S./Imperial
    case Yard, Foot, Inch
    // Length: Metric
    case Meter, Centimeter, Millimeter
    // Miscellaneous containers
    case Box, Can, Jar, Bottle, Package, Case, Pallet
    // Miscellanous individual terms
    case Loaf, Bunch, Head, Roll, Bar
    // Catch-all
    case Each
    
    public func pluralName() -> String 
    {
        switch self {
            case Each:
                return String(self)
            case Foot:
                return "Feet"
            case Loaf:
                return "Loaves"
            case Inch, Box, Bunch:
                return "\(self)es"
            default:
                return "\(self)s"
        }
    }
}
