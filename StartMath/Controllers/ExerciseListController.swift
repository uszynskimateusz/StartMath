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
    }
}

extension ExerciseListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        exerciseTab.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exercisesCell", for: indexPath)
        
        cell.textLabel?.text = exerciseTab[indexPath.row].title
        cell.selectionStyle = .none
        
        return cell
    }
}
