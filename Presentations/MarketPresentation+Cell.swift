//
//  MarketPresentation+Cell.swift
//  LoafBottleStick
//
//  Created by Joshua Caswell on 10/17/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

private let kMarketCellNibName = "LBSMarketCell"
private let kMarketCellReuseIdentifier = "MarketCell"

extension MarketPresentation
{
    class func registerCell(withCollectionView collectionView: UICollectionView)
    {
        let cellNib = UINib(nibName:kMarketCellNibName, bundle: nil)
        
        collectionView.registerNib(cellNib, forCellWithReuseIdentifier: kMarketCellReuseIdentifier)
    }
    
    private struct TableHolder
    {
        private static var tables: [MarketPresentation : LBSMarketTableController] = [:]
        
        static func table(forPresentation presentation: MarketPresentation) -> LBSMarketTableController
        {
            var table = self.tables[presentation]
            if table == nil {
            
                table = LBSMarketTableController(marketPresentation: presentation)
                self.tables[presentation] = table
            }
            
            return table!    //swiftlint:disable:this force_unwrapping
        }
    }
    
    var tableController: LBSMarketTableController {
        return TableHolder.table(forPresentation: self)
    }
    
    func configureCell(forCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath)
        -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kMarketCellReuseIdentifier,
                                                                         forIndexPath: indexPath) as! LBSMarketCell
        //swiftlint:disable:previous force_cast
        
        cell.tableView = self.tableController.tableView
        
        return cell
    }
}
