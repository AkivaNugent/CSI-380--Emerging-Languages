// WordSearch.swift
// Created for Assignment 5 of CSI 380

import Foundation

// YOU FILL IN HERE
// Feel free to put in additional utility code as long as you have
// no loops, no *mutable* global variables, and no custom classes.

// Replaces each character in a phone number with an array of the
// possible letters that could be in place of that character
// For instance, 234 becomes [["A", "B", "C"], ["D", "E", "F"], ["G", "H", "I"]]
public func letters(for phoneNumber: String) -> [[String]] {
    //map numbers to their letterstwitch
    //compactmap to letters
    let numLetterMap = ["1": ["1"],
    "2": ["A", "B", "C"],
    "3": ["D", "E", "F"],
    "4": ["G", "H", "I"],
    "5": ["J", "K", "L"],
    "6": ["M", "N", "O"],
    "7": ["P", "Q", "R", "S"],
    "8": ["T", "U", "V"],
    "9": ["W", "X", "Y", "Z"],
    "0": ["0"]]
    
    return phoneNumber.compactMap { numLetterMap[String($0)] }
}

// Finds all of the ordered permutations of a given
// array of arrays of strings
// combining each choice in one
// array with each choice in the next array, and so on to produce strings
// For instance permuations(of: [["a", "b"], ["c"], ["d", "e"]]) will return
// ["acd", "ace" "bcd", "bce"]
public func permutations(of arrays: [[String]]) -> [String] {
    //do from inside out
    //add letter from next set of letters to each in the first set
    //do it for all letters
    //flaten to strings
    //do it again for the next set of letters
    let permutations = arrays.reduce([""]) { lastPerm, nextSet in
        lastPerm.flatMap { partPerm in
            return nextSet.map { letter in
                return partPerm + letter
            }
        }
    }
    return permutations
}


// Finds all of the possible strings of characters that a phone number
// can potentially represent
// Uses letters(for:) and permutations(of:) to do this
public func possibles(for phoneNumber: String) -> [String] {
    let numbInLetters = letters(for: phoneNumber)
    let permutations = permutations(of: numbInLetters)
    
    return permutations
}

// Returns all of the words in a given *string* from the wordlist.txt file
// using only words in the word list of minimum length ofMinLength
public func wordsInString(_ string: String, ofMinLength length: UInt) -> [String] {
    //get word list word list
    //make sure case matches the test
    //filter list for only the strings contained in the passed string
    //filter list for length
    let wordsFromFile = WordList()
    let upperWords = wordsFromFile.words.map { $0.uppercased() }

    return upperWords.filter { word in
        string.uppercased().contains(word) && word.count >= length
    }
}

// Returns all possibles strings of characters that a phone number
// can potentially represent that contain words in words.txt
// greater than or equal to ofMinLength characters
public func possiblesWithWholeWords(ofMinLength length: UInt, for phoneNumber: String) -> [String] {
    //get word list
    //get permutations
    //make them uppercased like the last one
    //filter permutations for the ones with words
    //filter for length
    let wordsFromFile = WordList()
    let upperWords = wordsFromFile.words.map { $0.uppercased() }
    let allPerms = possibles(for: phoneNumber)
    let upperPerms = allPerms.map { $0.uppercased() }
    
    return upperPerms.filter { perm in
        upperWords.contains { word in
            word.count >= length && perm.contains(word)
        }
    }
}

// Returns the phone number mnemonics that have the most words present in words.txt
// within them (note that these words could be overlapping)
// For instance, if there are two mnemonics that contain three words from
// words.txt, it will return both of them, if the are no other mnemonics
// that contain more than three words
public func mostWords(for phoneNumber: String) -> [String] {
    //same rigamarole with getting lists and permulations
    //map a count onto the perms based on number of words
    //get the max count
    //filter perms for only the ones with a count == maxCount
    let wordsFromFile = WordList()
    let upperWords = wordsFromFile.words.map { $0.uppercased() }
    let allPerms = possibles(for: phoneNumber)
    let upperPerms = allPerms.map { $0.uppercased() }
    
    let wordsCount = upperPerms.map { perm in
        upperWords.filter { word in
            perm.contains(word)
        }.count
    }
    
    let maxCount = wordsCount.max() ?? 0
    
    return upperPerms.filter { perm in
        upperWords.filter { word in
            perm.contains(word)
        }.count == maxCount
    }
    
}

// Returns the phone number mnemonics with the longest words from words.txt
// If more than one word is tied for the longest, returns all of them
public func longestWords(for phoneNumber: String) -> [String] {
    //same rigamarole with getting lists and permulations
    //map a length for the perm onto the strings containing wordlist words
    //get the max length
    //filter perms for only those with a substring that == maxLength
    let wordsFromFile = WordList()
    let upperWords = wordsFromFile.words.map { $0.uppercased() }
    let allPerms = possibles(for: phoneNumber)
    let upperPerms = allPerms.map { $0.uppercased() }
    
    let longestWord = upperPerms.map { perm in
        upperWords.filter { word in
            perm.contains(word)
        }.map { $0.count}.max() ?? 0
    }
    
    let maxLength = longestWord.max()
    
    return upperPerms.filter { perm in
        upperWords.contains { word in
            perm.contains(word) && word.count == maxLength
        }
    }
}
