//
//  SingleExerciseController.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 14/12/2020.
//

import UIKit
import RealmSwift

class SingleExerciseController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageImageView: UIImageView!
    
    let realm = try? Realm()
    var exercise: Exercise?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let e = exercise {
            titleLabel.text = e.title
            descriptionLabel.text = e.descriptionExercise
            imageImageView.image = UIImage(data: e.image as Data)
        }
    }
    @IBAction func showAnswearPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Answear: ", message: exercise?.answer, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
        
        if let exerciseDone = exercise {
            do {
                if let realM = realm {
                    try realM.write {
                        exerciseDone.done = true
                    }
                }
            } catch {
                print("Error with updating, \(error.localizedDescription)")
            }
        }
    }
}
