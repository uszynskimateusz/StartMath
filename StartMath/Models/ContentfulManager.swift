//
//  ContentfulManager.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 12/12/2020.
//

import Foundation

protocol ContentfulManagerDelegate {
    func didUpdateSection(_ sections: [SectionModel])
}

struct ContentfulManager {
    let sectionURL = "https://cdn.contentful.com/spaces/ail58xyc0gux/environments/master/entries?access_token=uC-Uml8K_vA7wJMZOx0Aoi92ryGnXwcl7Gj0b1R_bac&content_type=section"
    
    var delegate: ContentfulManagerDelegate?
    
    func fetchSection() {
        //create URL
        if let url = URL(string: sectionURL) {
            
            //create URLSession
            let session = URLSession(configuration: .default)
            
            //give session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    let sectionList = self.parseSection(section: safeData)
                    delegate?.didUpdateSection(sectionList)
                }
            }
            
            //start task
            task.resume()
        }
    }
    
    func parseSection(section: Data) -> [SectionModel]{
        let decoder = JSONDecoder()
        var sectionList: [SectionModel] = []
        do {
            let decodedData = try decoder.decode(SectionData.self, from: section)
            for d in decodedData.items {
                let sectionModel = SectionModel(title: d.fields.title, introduction: d.fields.introduction.sys.id, flashcard: d.fields.flashcard.sys.id, exercise: d.fields.exercise.sys.id, test: d.fields.test.sys.id)
                
                sectionList.append(sectionModel)
            }
        } catch {
            print(error)
        }
        
        return sectionList
    }
}
