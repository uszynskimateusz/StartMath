//
//  ContentfulManager.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 12/12/2020.
//

import UIKit
import RealmSwift

enum Names: String, CaseIterable {
    case exercise = "Exercise"
    case flashcard = "Flashcard"
    case test = "Test"
    case introduction = "Introduction"
    case title = "title"
}

protocol ContentfulManagerDelegate {
    func update()
}

struct ContentfulManager {
    let realm = try? Realm()
    
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
                    parseSection(data: safeData)
                }
            }
            
            task.resume() //start task
        }
    }
    
    func parseSection(data: Data) {
        var sections: Results<Section>?
        DispatchQueue.main.async {
            if let realM = realm {
                sections = realM.objects(Section.self)
            }
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
                fetchData(id: exercises, section: newSection, type: .exercise)
                
                var flashcards: [String] = []
                for f in d.fields.flashcards {
                    flashcards.append(f.sys.id)
                }
                fetchData(id: flashcards, section: newSection, type: .flashcard)
                
                var tests: [String] = []
                for t in d.fields.test {
                    tests.append(t.sys.id)
                }
                fetchData(id: tests, section: newSection, type: .test)
            }
            
        } catch {
            print("Error with decode exercise: \(error)")
        }
    }
    //MARK: - Fetch Data
    func parseData(data: Data, id: [String], secion: Section, type: Names) {
        var tests: Results<Test>?
        var exercises: Results<Exercise>?
        var flashcards: Results<Flashcard>?
        DispatchQueue.main.async {
            switch type {
            case .test:
                if let realM = realm {
                    tests = realM.objects(Test.self)
                }
                
            case .exercise:
                if let realM = realm {
                    exercises = realM.objects(Exercise.self)
                }
                
            case .flashcard:
                if let realM = realm {
                    flashcards = realM.objects(Flashcard.self)
                }
        
            default:
                break
            }
        }
        let decoder = JSONDecoder()
        do {
            switch type {
            case .test:
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
                            test.createdAt = d.sys.createdAt
                            test.updatedAt = d.sys.updatedAt
                            
                            DispatchQueue.main.async {
                                saveTest(test, section: secion, tests: tests)
                            }
                        }
                    }
                }
                
            case .exercise:
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
                                            newExer.modelar = d.fields.modelAr
                                            newExer.arMode = d.fields.trybAr
                                            newExer.createdAt = d.sys.createdAt
                                            newExer.updatedAt = d.sys.updatedAt
                                            
                                            DispatchQueue.main.async {
                                                saveExer(newExer, section: secion, exercises: exercises)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            case .flashcard:
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
                                            flash.createdAt = d.sys.createdAt
                                            flash.updatedAt = d.sys.updatedAt
                                            
                                            DispatchQueue.main.async {
                                                saveFlash(flash, section: secion, flashcards: flashcards)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            default:
                break
            }
        } catch {
            print("Error with decode Data: \(error)")
        }
    }
    
    func fetchData(id: [String], section: Section, type: Names) {
        var urlString = ""
        switch type {
        case .exercise:
            urlString = exerciseURL
        case .test:
            urlString = testURL
        case .flashcard:
            urlString = flashcardURL
        default:
            break
        }
        if let url = URL(string: urlString) { //entries URL
            let session = URLSession(configuration: .default) //url session create
            
            //give session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    parseData(data: safeData, id: id, secion: section, type: type)
                }
            }
            
            task.resume() //start task
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
            if let realM = realm {
                introductions = realM.objects(Introduction.self)
            }
        }
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(IntroductionData.self, from: data)
            for d in decodedData.items {
                if d.sys.id == id {
                    let newIntro = Introduction()
                    newIntro.title = d.fields.title
                    newIntro.descriptionIntroduction = d.fields.description
                    newIntro.createdAt = d.sys.createdAt
                    newIntro.updatedAt = d.sys.updatedAt
                    
                    
                    DispatchQueue.main.async {
                        saveIntro(newIntro, section: secion, introductions: introductions)
                    }
                }
            }
            
        } catch {
            print("Error with decode Intro: \(error)")
        }
    }
    
    //MARK: - Data Manipulation Method
    func saveTest(_ test: Test, section: Section, tests: Results<Test>?) {
        var exist = false
        if let testList = tests {
            for t in testList {
                if t.createdAt == test.createdAt {
                    exist = true
                    if t.updatedAt != test.updatedAt {
                        do {
                            if let realM = realm {
                                try realM.write {
                                    t.title = test.title
                                    t.descriptionTest = test.descriptionTest
                                    t.answerA = test.answerA
                                    t.answerB = test.answerB
                                    t.answerC = test.answerC
                                    t.answerD = test.answerD
                                    t.answerCorrect = test.answerCorrect
                                    t.updatedAt = test.updatedAt
                                }
                            }
                        } catch {
                            print("Error with update Test to Realm: \(error)")
                        }
                    }
                }
            }
        }
        
        if exist == false {
            do {
                if let realM = self.realm {
                    try realM.write {
                        section.tests.append(test)
                        delegate?.update()
                    }
                }
            } catch {
                print("Error with saving Test, \(error.localizedDescription)")
            }
        }
    }
    
    func saveFlash(_ flash: Flashcard, section: Section, flashcards: Results<Flashcard>?) {
        var exist = false
        if let flashList = flashcards {
            for f in flashList {
                if f.createdAt == flash.createdAt {
                    exist = true
                    if f.updatedAt != flash.updatedAt {
                        do {
                            if let realM = realm {
                                try realM.write {
                                    f.title = flash.title
                                    f.descriptionFlashcard = flash.descriptionFlashcard
                                    f.image = flash.image
                                    f.updatedAt = flash.updatedAt
                                }
                            }
                        } catch {
                            print("Error with update Flashcard to Realm: \(error)")
                        }
                    }
                }
            }
        }
        
        if exist == false {
            do {
                if let realM = self.realm {
                    try realM.write {
                        section.flashcards.append(flash)
                        delegate?.update()
                    }
                }
            } catch {
                print("Error with saving flshcard, \(error.localizedDescription)")
            }
        }
    }
    
    func saveExer(_ exer: Exercise, section: Section, exercises: Results<Exercise>?) {
        var exist = false
        if let exerList = exercises {
            for e in exerList {
                if e.createdAt == exer.createdAt {
                    exist = true
                    if e.updatedAt != exer.updatedAt {
                        do {
                            if let realM = realm {
                                try realM.write {
                                    e.title = exer.title
                                    e.descriptionExercise = exer.descriptionExercise
                                    e.answer = exer.answer
                                    e.updatedAt = exer.updatedAt
                                    e.image = exer.image
                                    e.arMode = exer.arMode
                                    e.modelar = exer.modelar
                                }
                            }
                        } catch {
                            print("Error with update Exer to Realm: \(error)")
                        }
                    }
                }
            }
        }
        
        if exist == false {
            do {
                if let realM = self.realm {
                    try realM.write {
                        section.exercises.append(exer)
                        delegate?.update()
                    }
                }
            } catch {
                print("Error with saving Exercise, \(error.localizedDescription)")
            }
        }
    }
    
    func saveIntro(_ intro: Introduction, section: Section, introductions: Results<Introduction>?) {
        var exist = false
        if let introList = introductions {
            for i in introList {
                if i.createdAt == intro.createdAt {
                    exist = true
                    if i.updatedAt != intro.updatedAt {
                        do {
                            if let realM = realm {
                                try realM.write {
                                    i.title = intro.title
                                    i.descriptionIntroduction = intro.descriptionIntroduction
                                    i.updatedAt = intro.updatedAt
                                }
                            }
                        } catch {
                            print("Error with update Introduction to Realm: \(error)")
                        }
                    }
                }
            }
        }
        if exist == false {
            do {
                if let realM = self.realm {
                    try realM.write {
                        section.introductions.append(intro)
                        delegate?.update()
                    }
                }
            } catch {
                print("Error with saving introductions, \(error.localizedDescription)")
            }
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
                            if let realM = realm {
                                try realM.write {
                                    s.title = newSection.title
                                    s.updatedAt = newSection.updatedAt
                                    s.exercises = newSection.exercises
                                    s.flashcards = newSection.flashcards
                                    s.introductions = newSection.introductions
                                    s.tests = newSection.tests
                                }
                            }
                        } catch {
                            print("Error with updating Section to Realm: \(error)")
                        }
                    }
                }
            }
        }
        
        if exist == false {
            do {
                if let realM = realm {
                    try realM.write {
                        realM.add(newSection)
                        delegate?.update()
                    }
                }
            } catch {
                print("Error with save Section to Realm: \(error)")
            }
        }
    }
}
