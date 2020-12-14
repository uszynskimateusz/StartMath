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
    }
}

extension FlashcardController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        flashcardTab.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "flashcardCell", for: indexPath)
        
        cell.textLabel?.text = flashcardTab[indexPath.row].title
        cell.selectionStyle = .none
        
        return cell
    }
    
    
}
