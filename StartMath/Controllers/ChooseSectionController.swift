//
//  SectionController.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 12/12/2020.
//

import UIKit
import RealmSwift

enum SectionNib: String {
    case sectionNibName = "SectionCell"
    case sectionIdentifier = "sectionCell"
}

class ChooseSectionController: UIViewController {
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var sectionTableView: UITableView!
    
    let realm = try? Realm()
    var sections: Results<Section>?
    
    var contentfulManager = ContentfulManager()
    
    //MARK: - Instance Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentfulManager.delegate = self
        contentfulManager.fetchAll()
        
        setTableView()
        
        loadSection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sectionTableView.reloadData()
    }
    
    //MARK: - Table View Methods
    func setTableView() {
        sectionTableView.dataSource = self
        sectionTableView.delegate = self
        sectionTableView.register(UINib(nibName: SectionNib.sectionNibName.rawValue, bundle: nil), forCellReuseIdentifier: SectionNib.sectionIdentifier.rawValue)
        sectionTableView.rowHeight = 75
    }
    
    //MARK: - Data Methods
    func loadSection() {
        if let realM = realm {
            sections = realM.objects(Section.self)
            sectionTableView.reloadData()
        }
    }
}


//MARK: - Table View Data Source Methods
extension ChooseSectionController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SectionNib.sectionIdentifier.rawValue, for: indexPath) as! SectionCell
        
        if let s = sections?[indexPath.row] {
            cell.sectionLabel.text = s.title
            cell.selectionStyle = .none
        }
        
        return cell
    }
}

//MARK: - Contentful Manager Delegate Method
extension ChooseSectionController: ContentfulManagerDelegate {
    func update() {
        sectionTableView.reloadData()
    }
}

//MARK: - Table View Delegate Method
extension ChooseSectionController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: SegueName.sectionSegue.rawValue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SectionController
        
        if let indexPath = sectionTableView.indexPathForSelectedRow {
            destinationVC.selectedSection = sections?[indexPath.row]
        }
    }
}

