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
    @IBOutlet weak var modelArButton: UIButton!
    
    let realm = try? Realm()
    var exercise: Exercise?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let e = exercise {
            titleLabel.text = e.title
            descriptionLabel.text = e.descriptionExercise
            imageImageView.image = UIImage(data: e.image as Data)
            modelArButton.isEnabled = e.trybar == "brak" ? false : true
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
    
    @IBAction func showARPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToAR", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ARModelController
        if let answerInt = Int(exercise!.answer) {
            destinationVC.maxItem = answerInt
        }
        
        if let tryb = exercise?.trybar {
            switch tryb {
            case "pokazywanie":
                destinationVC.type = .showing
                
            case "mierzenie":
                destinationVC.type = .measurement
            default:
                break
            }
        }
        
        if let model = exercise?.modelar {
            switch model {
            case "jabłko":
                destinationVC.itemSCNScene = "art.scnassets/apple.scn"
                destinationVC.itemChildNode = "Apple"
                
            case "banan":
                destinationVC.itemSCNScene = "art.scnassets/banana.scn"
                destinationVC.itemChildNode = "banana.obj"
                
            default:
                destinationVC.itemSCNScene = "art.scnassets/among_us.scn"
                destinationVC.itemChildNode = "among_us_001_wire_177088027"
            }
        }
    }
}
