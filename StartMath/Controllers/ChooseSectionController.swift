//
//  SectionController.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 12/12/2020.
//

import UIKit
import RealmSwift

class ChooseSectionController: UIViewController {
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var sectionTableView: UITableView!
    
    let realm = try? Realm()
    var sections: Results<Section>?
    
    var contentfulManager = ContentfulManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        contentfulManager.delegate = self
        sectionTableView.dataSource = self
        sectionTableView.delegate = self
        
        sectionTableView.register(UINib(nibName: K.sectionNib.rawValue, bundle: nil), forCellReuseIdentifier: K.sectionIdentifier.rawValue)
        
        contentfulManager.fetchAll()
        
        loadSection()
    }
    
    func loadSection() {
        if let realM = realm {
            sections = realM.objects(Section.self)
            sectionTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sectionTableView.reloadData()
    }
}

extension ChooseSectionController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.sectionIdentifier.rawValue, for: indexPath) as! SectionCell
        
        if let s = sections?[indexPath.row] {
            cell.sectionLabel.text = s.title
            cell.selectionStyle = .none
        }
        
        return cell
    }
}

extension ChooseSectionController: ContentfulManagerDelegate {
    func update() {
        sectionTableView.reloadData()
    }
}

extension ChooseSectionController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.sectionSegue.rawValue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SectionController
        
        if let indexPath = sectionTableView.indexPathForSelectedRow {
           destinationVC.selectedSection = sections?[indexPath.row]
        }
    }
}

