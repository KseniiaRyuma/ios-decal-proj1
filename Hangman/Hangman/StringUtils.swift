//
//  StringUtils.swift
//  Hangman
//
//  Created by Kseniia Ryuma on 2/26/17.
//  Copyright © 2017 Shawn D'Souza. All rights reserved.
//

import Foundation

extension String {
    
    // Returns true if the string contains only characters found in matchCharacters.
    func containsOnlyCharactersIn(matchCharacters: String) -> Bool {
        let disallowedCharacterSet = NSCharacterSet(charactersIn: matchCharacters).inverted
        
        return self.rangeOfCharacter(from: disallowedCharacterSet) == nil
    }
}


