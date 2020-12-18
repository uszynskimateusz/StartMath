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
                let alert = UIAlertController(title: "Score: ", message: "\(score) / \(t.count)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                }))
                alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { (action) in
                    self.score = 0
                    self.exerciseNumber = 0
                    self.updateUI()
                }))
                self.present(alert, animated: true)
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
            
            progressBar.progress = Float(exerciseNumber+1)/Float(t.count)
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
