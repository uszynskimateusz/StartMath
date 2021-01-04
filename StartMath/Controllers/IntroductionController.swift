//
//  IntroductionController.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 14/12/2020.
//

import UIKit
import SafariServices

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
    @IBAction func searchPressed(_ sender: UIButton) {
        if let title = titleLabel.text {
            let urlString = "https://www.google.com/search?q=\(title.forSorting())"
            guard let url = URL(string: urlString) else {
                return
            }
            let svc = SFSafariViewController(url: url)
            present(svc, animated: true, completion: nil)
        }
    }
}
