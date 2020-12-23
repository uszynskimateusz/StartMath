//
//  IntroductionController.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 14/12/2020.
//

import UIKit

class IntroductionController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var introduction: Introduction?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let i = introduction {
            titleLabel.text = i.title
            descriptionLabel.text = i.descriptionIntroduction
        }
    }
}
