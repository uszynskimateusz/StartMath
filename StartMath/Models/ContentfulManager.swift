//
//  ContentfulManager.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 12/12/2020.
//

import UIKit

protocol ContentfulManagerDelegate {
    func didUpdateSection(_ sections: [SectionModel])
    func didUpdateExercise(_ exercises: [ExerciseModel])
    func didUpdateFlashcard(_ flashcards: [FlashcardModel])
}

struct ContentfulManager {
    let sectionURL = "https://cdn.contentful.com/spaces/ail58xyc0gux/environments/master/entries?access_token=uC-Uml8K_vA7wJMZOx0Aoi92ryGnXwcl7Gj0b1R_bac&content_type=section"
    
    let exerciseURL =  "https://cdn.contentful.com/spaces/ail58xyc0gux/environments/master/entries?access_token=uC-Uml8K_vA7wJMZOx0Aoi92ryGnXwcl7Gj0b1R_bac&content_type=exercise"
    
    let flashcardURL = "https://cdn.contentful.com/spaces/ail58xyc0gux/environments/master/entries?access_token=uC-Uml8K_vA7wJMZOx0Aoi92ryGnXwcl7Gj0b1R_bac&content_type=flaschcard"
    
    var delegate: ContentfulManagerDelegate?
    
    //MARK: - Fetch Section Model
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
    
    //MARK: - Fetch Exercise Model
    func fetchExercise(exerciseID: [String]) {
        if let url = URL(string: exerciseURL) { //entries URL
            let session = URLSession(configuration: .default) //url session create
            
            //give session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    self.parseExercise(exerciseData: safeData, exerciseID)
                }
            }
            
            task.resume() //start task
        }
    }
    
    func parseExercise(exerciseData: Data, _ exerciseID: [String]) {
        let decoder = JSONDecoder()
        var exerciseTab: [ExerciseModel] = []
        do {
            let decodedData = try decoder.decode(ExerciseData.self, from: exerciseData)
            for e in exerciseID {
                for d in decodedData.items{
                    if d.sys.id == e {
                        for i in decodedData.includes.Asset {
                            if d.fields.image.sys.id == i.sys.id {
                                if let urlImage = URL(string: "https:\(i.fields.file.url)") {
                                    if let uiImage = UIImage(url: urlImage) {
                                        let exercise = ExerciseModel(title: d.fields.title, description: d.fields.description, answer: d.fields.answer, image: uiImage)
                                        exerciseTab.append(exercise)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } catch {
            print("Error with decode exercise: \(error)")
        }
        self.delegate?.didUpdateExercise(exerciseTab)
    }
    
    
    
    //MARK: - Fetch Flashcard Model
    func fetchFlashcard(flashcardID: [String]) {
        if let url = URL(string: flashcardURL) { //entries URL
            let session = URLSession(configuration: .default) //url session create
            
            //give session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    self.parseFlashcard(flashcardData: safeData, flashcardID)
                }
            }
            
            task.resume() //start task
        }
    }
    
    func parseFlashcard(flashcardData: Data, _ flashcardID: [String]) {
        let decoder = JSONDecoder()
        var flashcardTab: [FlashcardModel] = []
        do {
            let decodedData = try decoder.decode(FlashcardData.self, from: flashcardData)
            for f in flashcardID {
                for d in decodedData.items{
                    if d.sys.id == f {
                        for i in decodedData.includes.Asset {
                            if d.fields.image.sys.id == i.sys.id {
                                if let urlImage = URL(string: "https:\(i.fields.file.url)") {
                                    if let uiImage = UIImage(url: urlImage) {
                                        let flashcard = FlashcardModel(title: d.fields.title, description: d.fields.description, image: uiImage)
                                        flashcardTab.append(flashcard)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } catch {
            print("Error with decode exercise: \(error)")
        }
        self.delegate?.didUpdateFlashcard(flashcardTab)
    }
}

//MARK: - UIImage Extension
extension UIImage {
    convenience init?(url: URL?) {
        guard let url = url else { return nil }
        do {
            self.init(data: try Data(contentsOf: url))
        } catch {
            print("Cannot load image from url: \(url) with error: \(error)")
            return nil
        }
    }
}
