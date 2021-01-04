//
//  ExerciseListController.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 14/12/2020.
//

import UIKit
import RealmSwift
import CircleProgressBar

enum ExerciseNib: String {
    case exerciseNibName = "ExerciseCell"
    case exerciseIdentifier = "exercisesCell"
}

class ExerciseListController: UIViewController {
    
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var exercisesTableView: UITableView!
    @IBOutlet weak var circleProgressBar: CircleProgressBar!
    
    
    var exercises: Results<Exercise>?
    var selectedSection: Section? {
        didSet{
            loadExercises()
        }
    }
    //MARK: - UI Update Methods
    func calculateDoneExercise() {
        var counter = 0
        if let exerList = exercises {
            for e in exerList {
                if e.done == true {
                    counter += 1
                }
            }
            exerciseLabel.text = "\(counter) / \(exerList.count) done"
            let progressFLoat = Float(counter) / Float(exerList.count)
            circleProgressBar.setProgress(CGFloat(progressFLoat), animated: true)
        }
        
    }
    
    //MARK: - Data Methods
    func loadExercises() {
        exercises = selectedSection?.exercises.sorted(byKeyPath: Names.title.rawValue, ascending: true)
    }
    
    //MARK: - Instance Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView(exercisesTableView)
        
        calculateDoneExercise()
        
        updateProgressBar(bar: circleProgressBar)
    }
    
    func setTableView(_ table: UITableView) {
        table.dataSource = self
        table.delegate = self
        table.register(UINib(nibName: ExerciseNib.exerciseNibName.rawValue, bundle: nil), forCellReuseIdentifier: ExerciseNib.exerciseIdentifier.rawValue)
    }
    
    func updateProgressBar(bar: CircleProgressBar) {
        bar.progressBarWidth = CGFloat(5)
        bar.hintTextColor = UIColor.systemGreen
        bar.progressBarProgressColor = UIColor.systemGreen
        bar.hintTextFont = UIFont.systemFont(ofSize: 20)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        exercisesTableView.reloadData()
        calculateDoneExercise()
    }
}

//MARK: - Table View Data Source Methods
extension ExerciseListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        exercises?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseNib.exerciseIdentifier.rawValue, for: indexPath) as! ExerciseCell
        if let e = exercises?[indexPath.row] {
            cell.titleLabel.text = e.title
            cell.leftImageView.image = e.done ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "xmark.circle")
        } else {
            cell.titleLabel.text = "Brak zadań"
        }
        cell.selectionStyle = .none
        
        return cell
    }
}

//MARK: - Table View Delegate Methods
extension ExerciseListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: SegueName.singleExerSegue.rawValue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SingleExerciseController
        
        if let indexPath = exercisesTableView.indexPathForSelectedRow {
            destinationVC.exercise = exercises?[indexPath.row]
        }
    }
}
