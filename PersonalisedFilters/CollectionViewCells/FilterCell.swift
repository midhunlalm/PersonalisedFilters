//
//  FilterCell.swift
//  PersonalisedFilters
//
//  Created by Manjula Pajaniraja on 01/09/21.
//

import UIKit

class FilterCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .lightGray
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
}
