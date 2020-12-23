//
//  TestBrain.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 23/12/2020.
//

import Foundation
import RealmSwift

protocol TestBrainDelegate {
    func endTest()
}

struct TestBrain {
    
    var tests: Results<Test>?
    
    var exerciseNumber = 0
    var score = 0
    
    var delegate: TestBrainDelegate?
    
    mutating func checkAnswer(_ userAnswer: String) -> UIColor {
        if let t = tests {
            if userAnswer == t[exerciseNumber].answerCorrect {
                score += 1
                return UIColor.green
            } else {
                return UIColor.red
            }
        }
        
        return UIColor.clear
    }
    
    mutating func nextQuestion() {
        if let t = tests {
            if exerciseNumber < t.count - 1 {
                exerciseNumber += 1
            } else {
                delegate?.endTest()
            }
        }
    }
    
    func getQuestionText() -> String {
        if let t = tests {
            return t[exerciseNumber].title
        }
        return "Brak pytań"
    }
    
    func getDescriptionText() -> String {
        if let t = tests {
            return t[exerciseNumber].descriptionTest
        }
        return "Brak pytań"
    }
    
    func getAnswerAText() -> String {
        if let t = tests {
            return t[exerciseNumber].answerA
        }
        return "Brak pytań"
    }
    
    func getAnswerBText() -> String {
        if let t = tests {
            return t[exerciseNumber].answerB
        }
        return "Brak pytań"
    }
    
    func getAnswerCText() -> String {
        if let t = tests {
            return t[exerciseNumber].answerC
        }
        return "Brak pytań"
    }
    
    func getAnswerDText() -> String {
        if let t = tests {
            return t[exerciseNumber].answerD
        }
        return "Brak pytań"
    }
    
    func getAnswerCorrectText() -> String {
        if let t = tests {
            return t[exerciseNumber].answerCorrect
        }
        return "Brak pytań"
    }
    
    func getProgress() -> Float{
        if let t = tests {
            return Float(exerciseNumber+1)/Float(t.count)
        }
        
        return 1
    }
    
    func getScore() -> Int {
        return score
    }
    
    mutating func setScore(_ score: Int) {
        self.score = score
    }
    
    mutating func setExerciseNumber(_ exerciseNumber: Int) {
        self.exerciseNumber = exerciseNumber
    }
}
