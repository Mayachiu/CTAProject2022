//
//  ShopTableViewCell.swift
//  CTAProject
//
//  Created by 内山和輝 on 2022/01/21.
//

import UIKit

final class ShopTableViewCell: UITableViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var genreStationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(shop: Shop) {
        logoImageView.image = UIImage(url: shop.logoImage)
        shopNameLabel.text = shop.name
        budgetLabel.text = shop.budget.name
        genreStationLabel.text = "\(shop.genre.name)" + " / " + "\(shop.stationName)"
    }
}
