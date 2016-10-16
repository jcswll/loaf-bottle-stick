//
//  Presentations+Dummy.swift
//  LoafBottleStick
//
//  Created by Joshua Caswell on 10/15/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

import Foundation

public extension MarketPresentation
{
    class func dummy() -> MarketPresentation
    {
        return MarketPresentation(market: Market.dummy())
    }
}

extension Market
{
    private static func nextName() -> String
    {
        let names = ["Groceria Abbandando",
                     "Mercado de Luis",
                     "Klaus Lebensmittelmarkt",
                     "Épicerie Pierre",
                     "Doyle's Grocery",
                     "Hans supermarkt",
                     "Mercearia de João",
                     "प्रसाद की किराने की दुकान",
                     "Csucskari áruházi"]
        
        struct Indexer    //swiftlint:disable:this nesting
        {
            static var index = 0
        }
        
        let name = names[Indexer.index]
        
        Indexer.index += 1
        if Indexer.index >= names.count {
            Indexer.index = 0
        }
        
        return name
    }
    
    static func dummy() -> Market
    {
        return self.init(name: self.nextName(),
                        ident: NSUUID().UUIDString,
                    inventory: dummyInventory(),
                         trip: dummyTrip())
    }
}

private func dummyInventory() -> MarketList<Merch>
{
    let names = ["Broccoli",
                 "Carrots",
                 "Peas",
                 "Peppers",
                 "Emmenthaler",
                 "Toothpaste",
                 "Honey",
                 "Almond paste"]
    
    return MarketList(items: Set(names.map({ Merch(name: $0, unit: nil) })))
}
    
private func dummyTrip() -> MarketList<Purchase>
{
    return MarketList()
}
