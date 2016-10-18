//
//  MerchPresentation+CellDelgate.swift
//  LoafBottleStick
//
//  Created by Joshua Caswell on 10/17/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

extension MerchPresentation : MarketItemPresentation
{
    func configureCell(cell: LBSMarketItemCell)
    {
        cell.itemName = self.name
    }
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        return self.textFieldShouldEndEditing(textField)
    }
    
    public func textFieldShouldEndEditing(textField: UITextField) -> Bool
    {
        guard let text = textField.text where !text.isEmpty else {
            return false
        }
        
        self.name = text
        textField.resignFirstResponder()
        return true
    }
}
