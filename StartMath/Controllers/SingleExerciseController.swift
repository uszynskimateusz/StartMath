//
//  SingleExerciseController.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 14/12/2020.
//

import UIKit

class SingleExerciseController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageImageView: UIImageView!
    
    var selectedExercise: ExerciseModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if let s = selectedExercise {
            titleLabel.text = s.title
            descriptionLabel.text = s.description
            imageImageView.image = s.image
        }
    }
    @IBAction func showAnswearPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Answear: ", message: selectedExercise?.answer, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
}
