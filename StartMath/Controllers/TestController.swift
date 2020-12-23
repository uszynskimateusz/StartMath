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
    
    var testBrain = TestBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testBrain.delegate = self
        testBrain.tests = tests
        
        answearAButton.layer.cornerRadius = answearAButton.frame.size.height/5
        answearBButton.layer.cornerRadius = answearBButton.frame.size.height/5
        answearCButton.layer.cornerRadius = answearCButton.frame.size.height/5
        answearDButton.layer.cornerRadius = answearDButton.frame.size.height/5
        
        updateUI()
    }
    
    @objc func updateUI() {
        titleLabel.text = testBrain.getQuestionText()
        descriptionLabel.text = testBrain.getDescriptionText()
        answearAButton.setTitle(testBrain.getAnswerAText(), for: .normal)
        answearBButton.setTitle(testBrain.getAnswerBText(), for: .normal)
        answearCButton.setTitle(testBrain.getAnswerCText(), for: .normal)
        answearDButton.setTitle(testBrain.getAnswerDText(), for: .normal)
        
        progressBar.progress = testBrain.getProgress()
        
        answearAButton.backgroundColor = UIColor.clear
        answearBButton.backgroundColor = UIColor.clear
        answearCButton.backgroundColor = UIColor.clear
        answearDButton.backgroundColor = UIColor.clear
    }
    
    @IBAction func answearPressed(_ sender: UIButton) {
        let userAnswer = sender.currentTitle
        sender.backgroundColor = testBrain.checkAnswer(userAnswer!)
        
        testBrain.nextQuestion()
        
        Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
    }
}

extension TestController: TestBrainDelegate {
    func endTest() {
        if let t = tests {
            var accualScore = 0
            DispatchQueue.main.async {
                accualScore = self.testBrain.getScore()
            }
            let alert = UIAlertController(title: "Score: ", message: "\(accualScore) / \(t.count)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { (action) in
                self.testBrain.setScore(0)
                self.testBrain.setExerciseNumber(0)
                self.updateUI()
            }))
            
            self.present(alert, animated: true)
        }
    }
}
