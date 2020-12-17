//
//  TestController.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 14/12/2020.
//

import UIKit
import RealmSwift

class TestController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var answearAButton: UIButton!
    @IBOutlet weak var answearBButton: UIButton!
    @IBOutlet weak var answearCButton: UIButton!
    @IBOutlet weak var answearDButton: UIButton!
    
    var tests: Results<Test>?

    var exerciseNumber = 0
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
        // Do any additional setup after loading the view.
    }
    
    func checkAnswer(_ userAnswer: String) -> UIColor {
        if let t = tests {
            if userAnswer == t[exerciseNumber].answerCorrect {
                score += 1
                return UIColor.green //good answer
            } else {
                return UIColor.red //bad answer
            }
        }
        
        return UIColor.clear
    }
    
    func nextQuestion() {
        if let t = tests {
            if exerciseNumber < t.count - 1 {
                exerciseNumber += 1
            } else {
                score = 0
                exerciseNumber = 0
                
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc func updateUI() {
        if let t = tests {
            titleLabel.text = t[exerciseNumber].title
            descriptionLabel.text = t[exerciseNumber].descriptionTest
            answearAButton.setTitle(t[exerciseNumber].answerA, for: .normal)
            answearBButton.setTitle(t[exerciseNumber].answerB, for: .normal)
            answearCButton.setTitle(t[exerciseNumber].answerC, for: .normal)
            answearDButton.setTitle(t[exerciseNumber].answerD, for: .normal)
            
            progressBar.progress = Float(exerciseNumber+1)/Float(tests?.count ?? 1)
        }

        answearAButton.backgroundColor = UIColor.clear
        answearBButton.backgroundColor = UIColor.clear
        answearCButton.backgroundColor = UIColor.clear
        answearDButton.backgroundColor = UIColor.clear
    }
    
    @IBAction func answearPressed(_ sender: UIButton) {
        let userAnswer = sender.currentTitle
        sender.backgroundColor = checkAnswer(userAnswer!)
        
        nextQuestion()
        
        Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
    }
}
