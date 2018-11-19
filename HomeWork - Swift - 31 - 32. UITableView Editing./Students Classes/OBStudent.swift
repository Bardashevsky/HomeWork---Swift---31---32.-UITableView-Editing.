//
//  OBStudent.swift
//  HomeWork - Swift - 31 - 32. UITableView Editing.
//
//  Created by Oleksandr Bardashevskyi on 11/17/18.
//  Copyright © 2018 Oleksandr Bardashevskyi. All rights reserved.
//

import UIKit

class OBStudent: NSObject {

        var firstName = String()
        var lastName = String()
        var averageGrade = Float()
    
    
    func randomStudent() -> OBStudent {
        let student = OBStudent()
        student.firstName = randomName()
        student.lastName = randomName()
        student.averageGrade = Float(arc4random()%301) / 100 + 2
        return student
    }
    
    private func randomName () -> String {
        
        func randomLetter(count: Int) -> Int {
            return Int(arc4random())%count
        }
        
        var name = ""
        var arrayLoud = ["b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "w", "x", "y", "z"]
        var arrayVowels = ["a", "e", "i", "o", "u", "a", "e", "i", "o", "u", "a", "e", "i", "o", "u", "a", "e", "i", "o", "u"]
        var arrayAlphabet = arrayVowels
        arrayAlphabet += arrayLoud
        
        for i in 2..<10 {
            if i == 2 {
                name.append(arrayAlphabet[randomLetter(count: arrayAlphabet.count)])
            }
            if (name.hasPrefix("a") || name.hasPrefix("e") || name.hasPrefix("i") || name.hasPrefix("o") || name.hasPrefix("u")) {
                name.append(i % 2 == 0 ? arrayLoud[randomLetter(count: arrayLoud.count)] : arrayVowels[randomLetter(count: arrayVowels.count)])
            } else {
                name.append(i % 2 == 1 ? arrayLoud[randomLetter(count: arrayLoud.count)] : arrayVowels[randomLetter(count: arrayVowels.count)])
            }
        }
        return name.capitalized
    }
    

}
