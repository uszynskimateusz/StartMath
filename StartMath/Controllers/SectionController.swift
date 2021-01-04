//
//  SectionController.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 14/12/2020.
//

import UIKit
import RealmSwift

enum SegueName: String {
    case sectionSegue = "goToSection"
    case introSegue = "goToIntroduction"
    case exerListSegue = "goToExercisesList"
    case flashSegue = "goToFlashcards"
    case testSegue = "goToTest"
    case singleExerSegue = "goToSingleExercise"
}

class SectionController: UIViewController {
    
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var introductionButton: UIButton!
    @IBOutlet weak var exerciseButton: UIButton!
    @IBOutlet weak var flashcardButton: UIButton!
    @IBOutlet weak var testButton: UIButton!
    
    var exercises: Results<Exercise>?
    var flashcards: Results<Flashcard>?
    var introductions: Results<Introduction>?
    var tests: Results<Test>?
    
    var selectedSection: Section? {
        didSet{
            loadData()
        }
    }
    
    func calculate() {
        var counter = 0
        
        if let doneExer = exercises {
            for d in doneExer {
                if d.done == true {
                    counter += 1
                }
            }
            
            testButton.isEnabled = counter == doneExer.count ? true : false
        }
    }
    func loadData() {
        exercises = selectedSection?.exercises.sorted(byKeyPath: Names.title.rawValue, ascending: true)
        flashcards = selectedSection?.flashcards.sorted(byKeyPath: Names.title.rawValue, ascending: true)
        introductions = selectedSection?.introductions.sorted(byKeyPath: Names.title.rawValue, ascending: true)
        tests = selectedSection?.tests.sorted(byKeyPath: Names.title.rawValue, ascending: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sectionLabel.text = selectedSection?.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        calculate()
    }
    @IBAction func introductionButton(_ sender: UIButton) {
        performSegue(withIdentifier: SegueName.introSegue.rawValue, sender: sender)
    }
    
    @IBAction func exercisePressed(_ sender: UIButton) {
        performSegue(withIdentifier: SegueName.exerListSegue.rawValue, sender: sender)
    }
    
    @IBAction func flashcardPressed(_ sender: UIButton) {
        performSegue(withIdentifier: SegueName.flashSegue.rawValue, sender: sender)
    }
    
    @IBAction func testPressed(_ sender: UIButton) {
        performSegue(withIdentifier: SegueName.testSegue.rawValue, sender: sender)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case SegueName.introSegue.rawValue:
                let destinationVC = segue.destination as! IntroductionController
                destinationVC.introduction = introductions?.first
                
            case SegueName.exerListSegue.rawValue:
                let destinationVC = segue.destination as! ExerciseListController
                destinationVC.exercises = exercises
                destinationVC.selectedSection = selectedSection
                
            case SegueName.flashSegue.rawValue:
                let destinationVC = segue.destination as! FlashcardController
                destinationVC.flashcards = flashcards
                destinationVC.label = selectedSection?.title
                
            case SegueName.testSegue.rawValue:
                let destinationVC = segue.destination as! TestController
                destinationVC.tests = tests
                
            default: break
            }
        }
    }
}
