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
    var testBrain = TestBrain()
    
    //MARK: - Instance Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        testBrain.delegate = self
        testBrain.tests = tests
        
        setUI()
        
        updateUI()
    }
    
    //MARK: - Update UI
    func setUI() {
        answearAButton.layer.cornerRadius = 30
        answearBButton.layer.cornerRadius = 30
        answearCButton.layer.cornerRadius = 30
        answearDButton.layer.cornerRadius = 30
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
    
    //MARK: - Button Methods
    @IBAction func answearPressed(_ sender: UIButton) {
        let userAnswer = sender.currentTitle
        sender.backgroundColor = testBrain.checkAnswer(userAnswer!)
        
        testBrain.nextQuestion()
        
        Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
    }
}

//MARK: Test Brain Delegate Methods
extension TestController: TestBrainDelegate {
    func endTest() {
        if let t = tests {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Score: ", message: "\(self.testBrain.getScore()) / \(t.count)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak self] _ in
                    guard let self = self else { return }
                    self.navigationController?.popViewController(animated: true)
                }))
                alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { [weak self] _ in
                    guard let self = self else { return }
                    self.testBrain.setScore(0)
                    self.testBrain.setExerciseNumber(0)
                    self.updateUI()
                }))
                
                self.present(alert, animated: true)
            }
        }
    }
}
