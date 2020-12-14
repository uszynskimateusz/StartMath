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
                var flashcards: [String] = []
                for f in d.fields.flashcards {
                    flashcards.append(f.sys.id)
                }
                
                var exercises: [String] = []
                for e in d.fields.exercises {
                    exercises.append(e.sys.id)
                }
                
                var tests: [String] = []
                for t in d.fields.test {
                    tests.append(t.sys.id)
                }
                
                let sectionModel = SectionModel(title: d.fields.title, introduction: d.fields.introduction.sys.id, flashcard: flashcards, exercise: exercises, test: tests)
                
                sectionList.append(sectionModel)
            }
        } catch {
            print("Error with decoding data: \(error)")
        }
        
        return sectionList
    }
}
