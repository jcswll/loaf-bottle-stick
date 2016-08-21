import XCTest
@testable import LoafBottleStickKit

class UnitEnumTests : XCTestCase
{
    func testPlurals()
    {
        let plurals: [Unit : String] =
                      [.Ton : "Tons", .Pound : "Pounds", .Ounce : "Ounces",
                       .Kilogram : "Kilograms", .Gram : "Grams",
                       .Milligram : "Milligrams", .Gallon : "Gallons",
                       .Quart : "Quarts", .Pint : "Pints", .Cup : "Cups",
                       .Tablespoon : "Tablespoons", .Teaspoon : "Teaspoons",
                       .Liter : "Liters", .Milliliter : "Milliliters",
                       .Yard : "Yards", .Foot : "Feet", .Inch : "Inches",
                       .Meter : "Meters", .Centimeter : "Centimeters",
                       .Millimeter : "Millimeters", .Box : "Boxes",
                       .Can : "Cans", .Jar : "Jars", .Bottle : "Bottles",
                       .Package : "Packages", .Case : "Cases",
                       .Pallet : "Pallets", .Loaf : "Loaves",
                       .Bunch : "Bunches", .Head : "Heads", .Roll : "Rolls",
                       .Bar : "Bars", .Each : "Each"]

        for unit in Unit.Ton...Unit.Each {

            let computedPlural = unit.pluralName()
            
            guard let expectedPlural = plurals[unit] else {
                
                XCTFail("Expected value for plural of \(unit) not provided.")
                continue
            }

            XCTAssertEqual(expectedPlural, computedPlural)
        }
    }
}

/** Allow iteration over all cases */
extension Unit : ForwardIndexType
{
    // swiftlint:disable cyclomatic_complexity
    // swiftlint:disable function_body_length
    func successor() -> Unit
    {
        switch self {
            case .Ton:
                return .Pound
            case .Pound:
                return .Ounce
            case .Ounce:
                return .Kilogram
            case .Kilogram:
                return .Gram
            case .Gram:
                return .Milligram
            case .Milligram:
                return .Gallon
            case .Gallon:
                return .Quart
            case .Quart:
                return .Pint
            case .Pint:
                return .Cup
            case .Cup:
                return .Tablespoon
            case .Tablespoon:
                return .Teaspoon
            case .Teaspoon:
                return .Liter
            case .Liter:
                return .Milliliter
            case .Milliliter:
                return .Yard
            case .Yard:
                return .Foot
            case .Foot:
                return .Inch
            case .Inch:
                return .Meter
            case .Meter:
                return .Centimeter
            case .Centimeter:
                return .Millimeter
            case .Millimeter:
                return .Box
            case .Box:
                return .Can
            case .Can:
                return .Jar
            case .Jar:
                return .Bottle
            case .Bottle:
                return .Package
            case .Package:
                return .Case
            case .Case:
                return .Pallet
            case .Pallet:
                return .Loaf
            case .Loaf:
                return .Bunch
            case .Bunch:
                return .Head
            case .Head:
                return .Roll
            case .Roll:
                return .Bar
            case .Bar:
                return .Each
            case .Each:
                return .Each
        }
    }
}
