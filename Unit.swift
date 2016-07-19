public enum Unit
{
    case Ton, Pound, Ounce
    case Kilogram, Gram
    case Gallon, Quart, Pint, Cup, Tablespoon, Teaspoon
    case Liter, Milliliter
    case Yard, Foot, Inch
    case Meter, Centimeter, Millimeter
    case Box, Can, Jar, Bottle, Roll, Package, Case
    case Loaf, Bunch, Head
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
