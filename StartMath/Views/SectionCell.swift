//
//  SectionCell.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 23/12/2020.
//

import UIKit

class SectionCell: UITableViewCell {
    @IBOutlet weak var sectionBubble: UIView!
    @IBOutlet weak var sectionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        sectionBubble.layer.cornerRadius = sectionBubble.frame.size.height/3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
