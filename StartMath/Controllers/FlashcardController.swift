//
//  FlashcardController.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 14/12/2020.
//

import UIKit
import RealmSwift

class FlashcardController: UIViewController {
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var flashcardTableView: UITableView!
    
    var flashcards: Results<Flashcard>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        flashcardTableView.dataSource = self
        
        flashcardTableView.register(UINib(nibName: "FlashcardCell", bundle: nil), forCellReuseIdentifier: "flashcardCell")
    }
}

extension FlashcardController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        flashcards?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "flashcardCell", for: indexPath) as! FlashcardCell
        if let f = flashcards?[indexPath.row] {
            cell.titleLabel.text = f.title
            cell.descriptionLabel.text = f.descriptionFlashcard
            cell.bottomImageView.image = UIImage(data: f.image as Data)
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
}
