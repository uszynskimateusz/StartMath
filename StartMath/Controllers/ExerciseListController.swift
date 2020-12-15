//
//  ExerciseListController.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 14/12/2020.
//

import UIKit

class ExerciseListController: UIViewController {
    
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var exercisesTableView: UITableView!
    
    var exerciseTab: [ExerciseModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        exercisesTableView.dataSource = self
        exercisesTableView.delegate = self
        
        exercisesTableView.register(UINib(nibName: "ExerciseCell", bundle: nil), forCellReuseIdentifier: "exercisesCell")
    }
}

extension ExerciseListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        exerciseTab.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exercisesCell", for: indexPath) as! ExerciseCell
        
        cell.titleLabel.text = exerciseTab[indexPath.row].title
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
            destinationVC.selectedExercise = exerciseTab[indexPath.row]
        }
    }
}
