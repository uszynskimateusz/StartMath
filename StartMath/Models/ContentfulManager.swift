//
//  ContentfulManager.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 12/12/2020.
//

import UIKit
import RealmSwift

protocol ContentfulManagerDelegate {
    func didUpdateSection(_ sections: [SectionModel])
    func didUpdateExercise(_ exercises: [ExerciseModel])
    func didUpdateFlashcard(_ flashcards: [FlashcardModel])
    func didUpdateIntroducton(_ introduction: IntroductionModel)
    func didUpdateTest(_ test: [TestModel])
    
    func update()
}

struct ContentfulManager {
    let realm = try! Realm()
    
    let sectionURL = "https://cdn.contentful.com/spaces/ail58xyc0gux/environments/master/entries?access_token=uC-Uml8K_vA7wJMZOx0Aoi92ryGnXwcl7Gj0b1R_bac&content_type=section"
    
    let exerciseURL =  "https://cdn.contentful.com/spaces/ail58xyc0gux/environments/master/entries?access_token=uC-Uml8K_vA7wJMZOx0Aoi92ryGnXwcl7Gj0b1R_bac&content_type=exercise"
    
    let flashcardURL = "https://cdn.contentful.com/spaces/ail58xyc0gux/environments/master/entries?access_token=uC-Uml8K_vA7wJMZOx0Aoi92ryGnXwcl7Gj0b1R_bac&content_type=flaschcard"
    
    let introductionURL = "https://cdn.contentful.com/spaces/ail58xyc0gux/environments/master/entries?access_token=uC-Uml8K_vA7wJMZOx0Aoi92ryGnXwcl7Gj0b1R_bac&content_type=introduction"
    
    let testURL = "https://cdn.contentful.com/spaces/ail58xyc0gux/environments/master/entries?access_token=uC-Uml8K_vA7wJMZOx0Aoi92ryGnXwcl7Gj0b1R_bac&content_type=exerciseTest"
    
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
                
                let sectionModel = SectionModel(title: d.fields.title, introduction: d.fields.introduction.sys.id, flashcard: flashcards, exercise: exercises, test: tests, updatedAt: d.sys.updatedAt)
                
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
    
    //MARK: - Fetch Introduction Model
    func fetchIntroduction(introductionID: String) {
        if let url = URL(string: introductionURL) { //entries URL
            let session = URLSession(configuration: .default) //url session create
            
            //give session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    self.parseIntroduction(introductionData: safeData, introductionID)
                }
            }
            
            task.resume() //start task
        }
    }
    
    func parseIntroduction(introductionData: Data, _ introductionID: String) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(IntroductionData.self, from: introductionData)
            for d in decodedData.items {
                if d.sys.id == introductionID {
                    let introduction = IntroductionModel(title: d.fields.title, description: d.fields.description)
                    self.delegate?.didUpdateIntroducton(introduction)
                }
            }
            
        } catch {
            print("Error with decode exercise: \(error)")
        }
    }
    
    //MARK: - Fetch Test Model
    func fetchTest(testID: [String]) {
        if let url = URL(string: testURL) { //entries URL
            let session = URLSession(configuration: .default) //url session create
            
            //give session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    self.parseTest(testData: safeData, testID)
                }
            }
            
            task.resume() //start task
        }
    }
    
    func parseTest(testData: Data, _ testID: [String]) {
        let decoder = JSONDecoder()
        var testTab: [TestModel] = []
        do {
            let decodedData = try decoder.decode(TestData.self, from: testData)
            for t in testID {
                for d in decodedData.items {
                    if d.sys.id == t {
                        let test = TestModel(title: d.fields.title, description: d.fields.description, answerA: d.fields.answerA, answerB: d.fields.answerB, answerC: d.fields.answerC, answerD: d.fields.answerD, answerCorrect: d.fields.answerCorrect)
                        testTab.append(test)
                    }
                }
            }
            
        } catch {
            print("Error with decode exercise: \(error)")
        }
        self.delegate?.didUpdateTest(testTab)
    }
    
    //MARK: - REALM
    
    func fetchAll(){
        if let url = URL(string: sectionURL) { //entries URL
            let session = URLSession(configuration: .default) //url session create
            
            //give session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    parseJSON(data: safeData)
                }
            }
            
            task.resume() //start task
        }
    }
    
    func parseJSON(data: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(SectionData.self, from: data)
            for d in decodedData.items {
                let newSection = Section()
                newSection.title = d.fields.title
                newSection.updatedAt = d.sys.updatedAt
                DispatchQueue.main.async {
                    saveSection(newSection)
                }
                
                fetchIntro(introID: d.fields.introduction.sys.id, section: newSection)
                
                var exercises: [String] = []
                for e in d.fields.exercises {
                    exercises.append(e.sys.id)
                }
                fetchExer(exerID: exercises, section: newSection)
                
                var flashcards: [String] = []
                for f in d.fields.flashcards {
                    flashcards.append(f.sys.id)
                }
                fetchFlash(flashID: flashcards, section: newSection)
                
                var tests: [String] = []
                for t in d.fields.test {
                    tests.append(t.sys.id)
                }
                fetchTest(testID: tests, section: newSection)
                
            }
            
        } catch {
            print("Error with decode exercise: \(error)")
        }
    }
    
    func fetchIntro(introID: String, section: Section) {
        if let url = URL(string: introductionURL) { //entries URL
            let session = URLSession(configuration: .default) //url session create
            
            //give session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    parseIntro(data: safeData, id: introID, secion: section)
                }
            }
            
            task.resume() //start task
        }
    }
    
    func parseIntro(data: Data, id: String, secion: Section) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(IntroductionData.self, from: data)
            for d in decodedData.items {
                if d.sys.id == id {
                    let newIntro = Introduction()
                    newIntro.title = d.fields.title
                    newIntro.descriptionIntroduction = d.fields.description
                    
                    DispatchQueue.main.async {
                        saveIntro(newIntro, section: secion)
                    }
                }
            }
            
        } catch {
            print("Error with decode Intro: \(error)")
        }
    }
    
    func fetchExer(exerID: [String], section: Section) {
        if let url = URL(string: exerciseURL) { //entries URL
            let session = URLSession(configuration: .default) //url session create
            
            //give session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    parseExer(data: safeData, id: exerID, secion: section)
                }
            }
            
            task.resume() //start task
        }
    }
    
    func parseExer(data: Data, id: [String], secion: Section) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ExerciseData.self, from: data)
            for e in id {
                for d in decodedData.items {
                    if d.sys.id == e {
                        for i in decodedData.includes.Asset {
                            if d.fields.image.sys.id == i.sys.id {
                                if let urlImage = URL(string: "https:\(i.fields.file.url)") {
                                    if let uiImage = UIImage(url: urlImage) {
                                        let newExer = Exercise()
                                        newExer.title = d.fields.title
                                        newExer.descriptionExercise = d.fields.description
                                        newExer.answer = d.fields.answer
                                        newExer.image = NSData(data: uiImage.pngData()!)
                                        
                                        DispatchQueue.main.async {
                                            saveExer(newExer, section: secion)
                                        }
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
    }
    
    func fetchFlash(flashID: [String], section: Section) {
        if let url = URL(string: flashcardURL) { //entries URL
            let session = URLSession(configuration: .default) //url session create
            
            //give session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    parseFlash(data: safeData, id: flashID, secion: section)
                }
            }
            
            task.resume() //start task
        }
    }
    
    func parseFlash(data: Data, id: [String], secion: Section) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(FlashcardData.self, from: data)
            for f in id {
                for d in decodedData.items{
                    if d.sys.id == f {
                        for i in decodedData.includes.Asset {
                            if d.fields.image.sys.id == i.sys.id {
                                if let urlImage = URL(string: "https:\(i.fields.file.url)") {
                                    if let uiImage = UIImage(url: urlImage) {
                                        let flash = Flashcard()
                                        flash.title = d.fields.title
                                        flash.descriptionFlashcard = d.fields.description
                                        flash.image = NSData(data: uiImage.pngData()!)
                                        
                                        DispatchQueue.main.async {
                                            saveFlash(flash, section: secion)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } catch {
            print("Error with decode flash: \(error)")
        }
    }
    
    func fetchTest(testID: [String], section: Section) {
        if let url = URL(string: testURL) { //entries URL
            let session = URLSession(configuration: .default) //url session create
            
            //give session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    parseTest(data: safeData, id: testID, secion: section)
                }
            }
            
            task.resume() //start task
        }
    }
    
    func parseTest(data: Data, id: [String], secion: Section) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(TestData.self, from: data)
            for t in id {
                for d in decodedData.items {
                    if d.sys.id == t {
                        //let test = TestModel(title: d.fields.title, description: d.fields.description, answerA: d.fields.answerA, answerB: d.fields.answerB, answerC: d.fields.answerC, answerD: d.fields.answerD, answerCorrect: d.fields.answerCorrect)
                        //testTab.append(test)
                        
                        let test = Test()
                        test.title = d.fields.title
                        test.descriptionTest = d.fields.description
                        test.answerA = d.fields.answerA
                        test.answerB = d.fields.answerB
                        test.answerC = d.fields.answerC
                        test.answerD = d.fields.answerD
                        test.answerCorrect = d.fields.answerCorrect
                        
                        DispatchQueue.main.async {
                            saveTest(test, section: secion)
                        }
                    }
                }
            }
            
        } catch {
            print("Error with decode Test: \(error)")
        }
    }
    
    func saveTest(_ test: Test, section: Section) {
        do {
            try self.realm.write {
                section.tests.append(test)
                print("Added new Test \(test.title) to \(section.title)")
                delegate?.update()
            }
        } catch {
            print("Error with saving Test, \(error.localizedDescription)")
        }
    }
    
    func saveFlash(_ flash: Flashcard, section: Section) {
        do {
            try self.realm.write {
                section.flashcards.append(flash)
                print("Added new Flash \(flash.title) to \(section.title)")
                delegate?.update()
            }
        } catch {
            print("Error with saving flshcard, \(error.localizedDescription)")
        }
    }
    
    func saveExer(_ exer: Exercise, section: Section) {
        do {
            try self.realm.write {
                section.exercises.append(exer)
                print("Added new Exer \(exer.title) to \(section.title)")
                delegate?.update()
            }
        } catch {
            print("Error with saving Exercise, \(error.localizedDescription)")
        }
    }
    
    func saveIntro(_ intro: Introduction, section: Section) {
        do {
            try self.realm.write {
                section.introductions.append(intro)
                print("Added new Intro \(intro.title) to \(section.title)")
                delegate?.update()
            }
        } catch {
            print("Error with saving introductions, \(error.localizedDescription)")
        }
    }
    
    func saveSection(_ section: Section) {
        do {
            try realm.write {
                realm.add(section)
                print("Save new section: \(section.title)")
                delegate?.update()
            }
        } catch {
            print("Error with save Section to Realm: \(error)")
        }
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
