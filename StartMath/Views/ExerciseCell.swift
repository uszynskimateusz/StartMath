//
//  ExerciseCell.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 15/12/2020.
//

import UIKit

class ExerciseCell: UITableViewCell {
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var exerciseBubble: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        exerciseBubble.layer.cornerRadius = exerciseBubble.frame.size.height/3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
