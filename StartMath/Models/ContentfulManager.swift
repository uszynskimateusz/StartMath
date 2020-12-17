//
//  ContentfulManager.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 12/12/2020.
//

import UIKit
import RealmSwift

protocol ContentfulManagerDelegate {
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
    
    //MARK: - Fetch Sections
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
        var sections: Results<Section>?
        DispatchQueue.main.async {
            sections = realm.objects(Section.self)
        }
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(SectionData.self, from: data)
            for d in decodedData.items {
                let newSection = Section()
                newSection.title = d.fields.title
                newSection.updatedAt = d.sys.updatedAt
                newSection.createdAt = d.sys.createdAt
    
                DispatchQueue.main.async {
                    saveSection(newSection, sections: sections)
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
    
    
    //MARK: Fetch Introduction
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
        var introductions: Results<Introduction>?
        DispatchQueue.main.async {
            introductions = realm.objects(Introduction.self)
        }
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(IntroductionData.self, from: data)
            for d in decodedData.items {
                if d.sys.id == id {
                    let newIntro = Introduction()
                    newIntro.title = d.fields.title
                    newIntro.descriptionIntroduction = d.fields.description
                    
                    DispatchQueue.main.async {
                        saveIntro(newIntro, section: secion, introductions: introductions)
                    }
                }
            }
            
        } catch {
            print("Error with decode Intro: \(error)")
        }
    }
    
    //MARK: Fetch Exercise
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
    
    //MARK: Fetch Flashcard
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
    
    //MARK: Fetch Test
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
    
    //MARK: - Data Manipulation Method
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
    
    func saveIntro(_ intro: Introduction, section: Section, introductions: Results<Introduction>?) {
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
    
    func saveSection(_ newSection: Section, sections: Results<Section>?) {
        var exist = false
        if let secionList = sections {
            for s in secionList {
                if s.createdAt == newSection.createdAt{
                    exist = true
                    if s.updatedAt != newSection.updatedAt {
                        do {
                            try realm.write {
                                s.title = newSection.title
                                s.updatedAt = newSection.updatedAt
                                s.exercises = newSection.exercises
                                s.flashcards = newSection.flashcards
                                s.introductions = newSection.introductions
                                s.tests = newSection.tests
                            }
                        } catch {
                            print("Error with save Section to Realm: \(error)")
                        }
                    }
                }
            }
        }
        
        if exist == false {
            do {
                try realm.write {
                    realm.add(newSection)
                    print("Save new section: \(newSection.title)")
                    delegate?.update()
                }
            } catch {
                print("Error with save Section to Realm: \(error)")
            }
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
