//
//  MerchPresentation+Cell.swift
//  LoafBottleStick
//
//  Created by Joshua Caswell on 10/17/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

private let kMarketItemCellNibName = "LBSMarketItemCell"
private let kMarketItemCellIdentifier = "MarketItemCell"

extension MerchPresentation : MarketItemPresentation
{
    class func registerCell(forTableView tableView: UITableView)
    {
        let cellNib = UINib(nibName: kMarketItemCellNibName, bundle: nil)
        
        tableView.registerNib(cellNib, forCellReuseIdentifier: kMarketItemCellIdentifier)
    }
    
    public func configureCell(inTableView tableView: UITableView, atIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(kMarketItemCellIdentifier,
                                                               forIndexPath: indexPath) as! LBSMarketItemCell
        //swiftlint:disable:previous force_cast

        cell.presentation = self
        cell.itemName = self.name
        
        return cell
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
