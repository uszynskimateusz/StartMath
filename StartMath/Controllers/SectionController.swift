//
//  SectionController.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 14/12/2020.
//

import UIKit

class SectionController: UIViewController {

    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var introductionButton: UIButton!
    @IBOutlet weak var exerciseButton: UIButton!
    @IBOutlet weak var flashcardButton: UIButton!
    @IBOutlet weak var testButton: UIButton!
    
    var selectedSection: SectionModel?
    var exerciseList: [ExerciseModel] = []
    var flashcardList: [FlashcardModel] = []
    var introduction: IntroductionModel?
    var testList: [TestModel] = []
    
    var contentfulManager = ContentfulManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        contentfulManager.delegate = self
        
        introductionButton.isEnabled = false
        exerciseButton.isEnabled = false
        flashcardButton.isEnabled = false
        testButton.isEnabled = false
        
        if let section = selectedSection {
            contentfulManager.fetchExercise(exerciseID: section.exercise)
            contentfulManager.fetchFlashcard(flashcardID: section.flashcard)
            contentfulManager.fetchIntroduction(introductionID: section.introduction)
            contentfulManager.fetchTest(testID: section.test)
            
            sectionLabel.text = section.title
        }

    }
    @IBAction func introductionButton(_ sender: UIButton) {
        performSegue(withIdentifier: "goToIntroduction", sender: sender)
    }
    
    @IBAction func exercisePressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToExercisesList", sender: sender)
    }
    
    @IBAction func flashcardPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToFlashcards", sender: sender)
    }
    
    @IBAction func testPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToTest", sender: sender)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "goToIntroduction":
                let destinationVC = segue.destination as! IntroductionController
                if let i = introduction {
                    destinationVC.introduction = i
                }
            
            case "goToExercisesList":
                let destinationVC = segue.destination as! ExerciseListController
                destinationVC.exerciseTab = exerciseList
                
            case "goToFlashcards":
                let destinationVC = segue.destination as! FlashcardController
                destinationVC.flashcardTab = flashcardList
                
            case "goToTest":
                let destinationVC = segue.destination as! TestController
                destinationVC.testTab = testList
                
            default: break
                
            }
        }
    }
    

}

extension SectionController: ContentfulManagerDelegate {
    func didUpdateTest(_ test: [TestModel]) {
        testList = test
        
        DispatchQueue.main.async {
            self.testButton.isEnabled = true
        }
    }
    
    func didUpdateIntroducton(_ introduction: IntroductionModel) {
        self.introduction = introduction
        
        DispatchQueue.main.async {
            self.introductionButton.isEnabled = true
        }
    }
    
    func didUpdateFlashcard(_ flashcards: [FlashcardModel]) {
        flashcardList = flashcards
        
        DispatchQueue.main.async {
            self.flashcardButton.isEnabled = true
        }
    }
    
    func didUpdateSection(_ sections: [SectionModel]) {
        
    }
    
    func didUpdateExercise(_ exercises: [ExerciseModel]) {
        exerciseList = exercises
        
        DispatchQueue.main.async {
            self.exerciseButton.isEnabled = true
        }
    }
}
