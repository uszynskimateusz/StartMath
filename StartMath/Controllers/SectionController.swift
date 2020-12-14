//
//  SectionController.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 14/12/2020.
//

import UIKit

class SectionController: UIViewController {
    
    @IBOutlet weak var testTableView: UITableView!
    @IBOutlet weak var sectionLabel: UILabel!
    
    var selectedSection: SectionModel?
    var exerciseList: [ExerciseModel] = []
    var flashcardList: [FlashcardModel] = []
    var introduction: IntroductionModel?
    
    var contentfulManager = ContentfulManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        testTableView.dataSource = self
        contentfulManager.delegate = self
        
        if let section = selectedSection {
            contentfulManager.fetchExercise(exerciseID: section.exercise)
            contentfulManager.fetchFlashcard(flashcardID: section.flashcard)
            contentfulManager.fetchIntroduction(introductionID: section.introduction)
            
            sectionLabel.text = section.title
        }

    }

}

extension SectionController: ContentfulManagerDelegate {
    func didUpdateIntroducton(_ introduction: IntroductionModel) {
        self.introduction = introduction
        
        if let i = self.introduction {
            DispatchQueue.main.async {
                self.sectionLabel.text = i.title
            }
        }
    }
    
    func didUpdateFlashcard(_ flashcards: [FlashcardModel]) {
        flashcardList = flashcards
        
        DispatchQueue.main.async {
            self.testTableView.reloadData()
        }
    }
    
    func didUpdateSection(_ sections: [SectionModel]) {
        
    }
    
    func didUpdateExercise(_ exercises: [ExerciseModel]) {
        exerciseList = exercises
    }
}

extension SectionController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flashcardList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "testCell", for: indexPath)
        
        cell.textLabel?.text = flashcardList[indexPath.row].title
        
        return cell
    }
}
