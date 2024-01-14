//
//  CryptoTableViewCell.swift
//  CryptoCrazyRxMVVM
//
//  Created by hasan bilgin on 20.10.2023.
//

import UIKit

class CryptoTableViewCell: UITableViewCell {

    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public var item : Crypto! {
        //surda currencyLabel ne ise Crypto nun currency sine eşitlicez demeke price de aynı şekilde
        didSet{
            self.currencyLabel.text = item.currency
            self.priceLabel.text = item.price
        }
    }

}
