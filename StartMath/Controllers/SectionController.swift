//
//  SectionController.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 14/12/2020.
//

import UIKit
import RealmSwift

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
    
    let realm = try! Realm()
    
    var selectedSection: Section? {
        didSet{
            loadExercises()
            loadFlashcards()
            loadIntroductions()
            loadTests()
        }
    }
    
    func loadExercises() {
        exercises = selectedSection?.exercises.sorted(byKeyPath: "title", ascending: true)
    }
    
    func loadFlashcards() {
        flashcards = selectedSection?.flashcards.sorted(byKeyPath: "title", ascending: true)
    }
    
    func loadIntroductions() {
        introductions = selectedSection?.introductions.sorted(byKeyPath: "title", ascending: true)
    }
    
    func loadTests() {
        tests = selectedSection?.tests.sorted(byKeyPath: "title", ascending: true)
    }
    
    var contentfulManager = ContentfulManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        contentfulManager.delegate = self
        
        sectionLabel.text = selectedSection?.title
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
                destinationVC.introduction = introductions?.first
            
            case "goToExercisesList":
                let destinationVC = segue.destination as! ExerciseListController
                destinationVC.exercises = exercises
                destinationVC.selectedSection = selectedSection
                
            case "goToFlashcards":
                let destinationVC = segue.destination as! FlashcardController
                destinationVC.flashcards = flashcards
                destinationVC.label = selectedSection?.title
                
            case "goToTest":
                let destinationVC = segue.destination as! TestController
                destinationVC.tests = tests
                
            default: break
                
            }
        }
    }
    

}

extension SectionController: ContentfulManagerDelegate {
    func update() {
    }
}
