//
//  StockTableViewCell.swift
//  MyApp
//
//  Created by ernist on 15/04/2017.
//  Copyright © 2017 ernist. All rights reserved.
//

import UIKit

class StockTableViewCell: UITableViewCell {

    @IBOutlet weak var QuotePrice2: UILabel!
    @IBOutlet weak var QuotePrice: UILabel!
    @IBOutlet weak var QuoteName: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lbIndicate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        QuotePrice2.layer.masksToBounds = true
        QuotePrice2.layer.cornerRadius = 5

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
