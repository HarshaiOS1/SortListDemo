//
//  ItemsListTableViewCell.swift
//  HexadDemoAssignment
//
//  Created by Harsha on 04/03/20.
//  Copyright © 2020 Harsha. All rights reserved.
//

import Foundation
import UIKit

protocol RatingButtonActionDelegate: class{
    func changeRating(tag: ListViewModel.Rate, cell: ItemsListTableViewCell)
}

class ItemsListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var decrementCounterButton: UIButton!
    @IBOutlet weak var incrementCounterButton: UIButton!
    
    @IBOutlet weak var itemTitleName: UILabel!
    var delegate: RatingButtonActionDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        if (sender as? UIButton)?.tag == 0 {
            delegate?.changeRating(tag: ListViewModel.Rate.increment, cell: self)
        } else if (sender as? UIButton)?.tag == 1 {
            delegate?.changeRating(tag: ListViewModel.Rate.decrement, cell: self)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
