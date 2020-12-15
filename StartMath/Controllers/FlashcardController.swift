//
//  FlashcardController.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 14/12/2020.
//

import UIKit

class FlashcardController: UIViewController {
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var flashcardTableView: UITableView!
    
    var flashcardTab: [FlashcardModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        flashcardTableView.dataSource = self
        
        flashcardTableView.register(UINib(nibName: "FlashcardCell", bundle: nil), forCellReuseIdentifier: "flashcardCell")
    }
}

extension FlashcardController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        flashcardTab.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "flashcardCell", for: indexPath) as! FlashcardCell
        
        cell.titleLabel.text = flashcardTab[indexPath.row].title
        cell.descriptionLabel.text = flashcardTab[indexPath.row].description
        cell.bottomImageView.image = flashcardTab[indexPath.row].image
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    
}
