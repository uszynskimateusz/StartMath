//
//  String+Extensions.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 30/12/2020.
//

import Foundation

extension String {
    func forSorting() -> String {
        let set = [("ą", "a"), ("ć", "c"), ("ę", "e"), ("ł", "l"), ("ń", "n"), ("ó", "o"), ("ś", "s"), ("ź", "z"), ("ż", "z")]
        let ab = self.lowercased()
        let new = ab.folding(options: .diacriticInsensitive, locale: nil)
        let final = new.replaceCharacters(characters: set)
        return final
    }
    
    func replaceCharacters(characters: [(String, String)]) -> String
    {
        var input: String = self
        let count = characters.count
        if count >= 1
        {
            for i in 1...count
            {
                let c = i - 1
                let first = input
                let working = first.replacingOccurrences(of: characters[c].0, with: characters[c].1)
                input = working
            }
        }
        return input.capitalizingFirstLetter()
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}
