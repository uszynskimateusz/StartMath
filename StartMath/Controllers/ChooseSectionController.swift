//
//  SectionController.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 12/12/2020.
//

import UIKit

class ChooseSectionController: UIViewController {
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var sectionTableView: UITableView!
    
    var sectionList: [SectionModel] = []
    
    var contentfulManager = ContentfulManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        contentfulManager.delegate = self
        sectionTableView.dataSource = self
        sectionTableView.delegate = self
        
        contentfulManager.fetchSection()
    }
}

extension ChooseSectionController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sectionCell", for: indexPath)
        
        cell.textLabel?.text = sectionList[indexPath.row].title
        
        return cell
    }
}

extension ChooseSectionController: ContentfulManagerDelegate {
    func didUpdateTest(_ test: [TestModel]) {
    }
    
    func didUpdateIntroducton(_ introduction: IntroductionModel) {
    }
    
    func didUpdateFlashcard(_ flashcards: [FlashcardModel]) {
        
    }
    
    func didUpdateExercise(_ exercises: [ExerciseModel]) {
        
    }
    
    func didUpdateSection(_ sections: [SectionModel]) {
        sectionList = sections
        DispatchQueue.main.async {
            self.sectionTableView.reloadData()
        }
    }
}

extension ChooseSectionController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToSection", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SectionController
        
        if let indexPath = sectionTableView.indexPathForSelectedRow {
            destinationVC.selectedSection = sectionList[indexPath.row]
        }
    }
}

