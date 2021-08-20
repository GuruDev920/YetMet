//
//  CountCell.swift
//  YetMet
//
//  Created by Sun on 2021/8/11.
//

import UIKit

class CountCell: UICollectionViewCell {

    @IBOutlet weak var lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var value: Int = 0 {
        didSet {
            lbl.text = "\(value)"
        }
    }
}
