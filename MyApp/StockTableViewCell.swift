//
//  StockTableViewCell.swift
//  MyApp
//
//  Created by ernist on 15/04/2017.
//  Copyright © 2017 ernist. All rights reserved.
//

import UIKit

class StockTableViewCell: UITableViewCell {

  
    @IBOutlet weak var myText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
