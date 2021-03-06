//
//  FlashcardController.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 14/12/2020.
//

import UIKit
import RealmSwift

enum FlashcardNib: String {
    case flashcardNibName = "FlashcardCell"
    case flashcardIdentifier = "flashcardCell"
}

class FlashcardController: UIViewController {
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var flashcardTableView: UITableView!
    
    var flashcards: Results<Flashcard>?
    var label: String?
    
    
    //MARK: - Instance Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setTableView(flashcardTableView)
        
        updateUI()
    }
    
    func setTableView(_ table: UITableView) {
        table.dataSource = self
        table.register(UINib(nibName: FlashcardNib.flashcardNibName.rawValue, bundle: nil), forCellReuseIdentifier: FlashcardNib.flashcardIdentifier.rawValue)
    }
    
    func updateUI() {
        if let s = label {
            sectionLabel.text = s
        }
    }
}

//MARK: UITable View Data Source Methods
extension FlashcardController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        flashcards?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FlashcardNib.flashcardIdentifier.rawValue, for: indexPath) as! FlashcardCell
        if let f = flashcards?[indexPath.row] {
            cell.titleLabel.text = f.title
            cell.descriptionLabel.text = f.descriptionFlashcard
            cell.bottomImageView.image = UIImage(data: f.image as Data)
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
}
