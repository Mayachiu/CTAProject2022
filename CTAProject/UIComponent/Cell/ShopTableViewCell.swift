//
//  ShopTableViewCell.swift
//  CTAProject
//
//  Created by 内山和輝 on 2022/01/21.
//

import UIKit

class ShopTableViewCell: UITableViewCell {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var budget: UILabel!
    @IBOutlet weak var genreStation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(shop: Shop) {
        logoImage.image = UIImage(url: shop.logoImage)
        shopName.text = shop.name
        budget.text = shop.budget.name
        genreStation.text = "\(shop.genre.name)" + " / " + "\(shop.stationName)"
    }
}
