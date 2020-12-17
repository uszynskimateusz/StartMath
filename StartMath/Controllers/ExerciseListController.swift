//
//  ExerciseListController.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 14/12/2020.
//

import UIKit
import RealmSwift

class ExerciseListController: UIViewController {
    
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var exercisesTableView: UITableView!
    
    var exercises: Results<Exercise>?
    var selectedSection: Section? {
        didSet{
            loadExercises()
        }
    }
    
    func loadExercises() {
        print("Wczytanie")
        exercises = selectedSection?.exercises.sorted(byKeyPath: "title", ascending: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        exercisesTableView.dataSource = self
        exercisesTableView.delegate = self
        
        
        exercisesTableView.register(UINib(nibName: "ExerciseCell", bundle: nil), forCellReuseIdentifier: "exercisesCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        exercisesTableView.reloadData()
    }
}

extension ExerciseListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        exercises?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exercisesCell", for: indexPath) as! ExerciseCell
        if let e = exercises?[indexPath.row] {
            cell.titleLabel.text = e.title
            cell.leftImageView.isHidden = e.done ? true : false
        } else {
            cell.titleLabel.text = "Brak zadań"
        }
        cell.selectionStyle = .none
        
        return cell
    }
}


extension ExerciseListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToSingleExercise", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SingleExerciseController

        if let indexPath = exercisesTableView.indexPathForSelectedRow {
            destinationVC.exercise = exercises?[indexPath.row]
        }
    }
}
