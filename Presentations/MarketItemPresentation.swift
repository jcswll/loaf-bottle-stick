//
//  MarketItemPresentation.swift
//  LoafBottleStick
//
//  Created by Joshua Caswell on 10/17/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

@objc public protocol MarketItemPresentation : class, UITextFieldDelegate
{
    func configureCell(inTableView tableView: UITableView, atIndexPath indexPath: NSIndexPath) -> UITableViewCell
}
