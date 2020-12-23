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
    var label: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flashcardTableView.dataSource = self
        
        flashcardTableView.register(UINib(nibName: K.flashcardNib.rawValue, bundle: nil), forCellReuseIdentifier: K.flashcardIdentifier.rawValue)
        
        if let s = label {
            sectionLabel.text = s
        }
    }
}

extension FlashcardController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        flashcards?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.flashcardIdentifier.rawValue, for: indexPath) as! FlashcardCell
        if let f = flashcards?[indexPath.row] {
            cell.titleLabel.text = f.title
            cell.descriptionLabel.text = f.descriptionFlashcard
            cell.bottomImageView.image = UIImage(data: f.image as Data)
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
}
