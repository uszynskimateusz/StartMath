//
//  ExerciseListController.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 14/12/2020.
//

import UIKit
import RealmSwift
import CircleProgressBar

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
    
    func calcExercise() {
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
    
    func loadExercises() {
        exercises = selectedSection?.exercises.sorted(byKeyPath: K.title.rawValue, ascending: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exercisesTableView.dataSource = self
        exercisesTableView.delegate = self
        
        
        exercisesTableView.register(UINib(nibName: K.exerciseNib.rawValue, bundle: nil), forCellReuseIdentifier: K.exerciseIdentifier.rawValue)
        
        calcExercise()
        
        circleProgressBar.progressBarWidth = CGFloat(5)
        circleProgressBar.hintTextColor = UIColor.systemGreen
        circleProgressBar.progressBarProgressColor = UIColor.systemGreen
        circleProgressBar.hintTextFont = UIFont.systemFont(ofSize: 20)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        exercisesTableView.reloadData()
        calcExercise()
    }
}

extension ExerciseListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        exercises?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.exerciseIdentifier.rawValue, for: indexPath) as! ExerciseCell
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
        performSegue(withIdentifier: K.singleExerSegue.rawValue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SingleExerciseController
        
        if let indexPath = exercisesTableView.indexPathForSelectedRow {
            destinationVC.exercise = exercises?[indexPath.row]
        }
    }
}
