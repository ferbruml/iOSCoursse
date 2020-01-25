//
//  PasswordGenerator.swift
//  SuperSenha
//
//  Created by Fernanda Brum on 20/10/18.
//  Copyright © 2018 Fernanda Brum. All rights reserved.
//

import Foundation

class PasswordGenerator {
    
    var numberOfCharacters: Int
    var useLetters: Bool
    var useNumbers: Bool
    var useCapitalLetters: Bool
    var useSpecialCharacters: Bool
    
    var passwords: [String] = [] // lista de todas as senhas
    
    private let letters = "abcdefghijklmnopqrstuvwxyz"
    private let numbers = "0123456789"
    private let specialCharacters = "!@#$%ˆ&*()_-+=~`|]}[{':;?/<>.,"
    
    init(numberOfCharacters: Int, useLetters: Bool, useNumbers: Bool, useCapitalLetters: Bool, useSpecialCharacters: Bool) {
        
        var numChars = min(numberOfCharacters, 16)
        numChars = max(numChars, 1)
        
        self.useLetters = useLetters
        self.useNumbers = useNumbers
        self.useCapitalLetters = useCapitalLetters
        self.useSpecialCharacters = useSpecialCharacters
        self.numberOfCharacters = numChars
        
        //self.numberOfCharacters = validate(numberOfCharacters)
    }
    
    // Valida a senha entre 1 e 16 caracteres
    func validate(_ numChars: Int) -> Int {
        
        var valid = min(numChars, 16)
        valid = max(valid, 1)
        
        return valid
    }
    
    func generate(total: Int) -> [String] {
        
        passwords.removeAll() // pq o permite ficar regerando e regerando as senhas
        
        var universe: String = ""
        
        if useLetters {
            universe += letters
        }
        
        if useNumbers {
            universe += numbers
        }
        
        if useCapitalLetters {
            universe += letters.uppercased()
        }
        
        if useSpecialCharacters {
            universe += specialCharacters
        }
        
        let universeArray = Array(universe)
        while (passwords.count < total) {
            var password = ""
            for _ in 1...numberOfCharacters {
                let index = Int(arc4random_uniform(UInt32(universeArray.count)))
                password += String(universeArray[index])
            }
            passwords.append(password)
        }
        
        return passwords
    }
}
