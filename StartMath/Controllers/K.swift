//
//  K.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 23/12/2020.
//

import Foundation

enum K: String {
    case exercise = "Exercise"
    case flashcard = "Flashcard"
    case test = "Test"
    case introduction = "Introduction"
    
    case title = "title"
    
    case sectionSegue = "goToSection"
    case introSegue = "goToIntroduction"
    case exerListSegue = "goToExercisesList"
    case flashSegue = "goToFlashcards"
    case testSegue = "goToTest"
    case singleExerSegue = "goToSingleExercise"
    
    case exerciseNib = "ExerciseCell"
    case flashcardNib = "FlashcardCell"
    case sectionNib = "SectionCell"
    
    case exerciseIdentifier = "exercisesCell"
    case flashcardIdentifier = "flashcardCell"
    case sectionIdentifier = "sectionCell"
    
    case apple = "jabłko"
    case banana = "banan"
}
