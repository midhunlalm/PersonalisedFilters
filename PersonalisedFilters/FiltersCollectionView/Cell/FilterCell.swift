//
//  FilterCell.swift
//  PersonalisedFilters
//
//  Created by Manjula Pajaniraja on 01/09/21.
//

import UIKit

class FilterCell: UICollectionViewCell {
    
    let label = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCellData(filter: String) {
        label.text = filter
        self.contentView.addSubview(label)
    }
    
}
