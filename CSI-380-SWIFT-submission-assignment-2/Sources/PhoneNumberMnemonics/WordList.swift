// WordList.swift
// Created for Assignment 5 of CSI 380
//
//Edited by Akiva Nugent
//CREDIT TO https://stackoverflow.com/questions/32021712/how-to-split-a-string-by-new-lines-in-swift
//For the splitting strings syntax
//CREIDT TO https://stackoverflow.com/questions/33868364/how-to-delete-last-path-component-of-a-string-in-swift
//For filepath .deletingLastPathComponent(). its not pretty, but it works.

import Foundation

// YOU FILL IN HERE
// You'll want to create a mechanism here for loading and querying
// words.txt. It's up to you how you do this. You may consider a struct.

struct WordList {
    let words: [String]

    init() {
        let filePath = URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("words.txt")

        if let content = try? String(contentsOf: filePath, encoding: .utf8) {
            words = content.components(separatedBy: .newlines)
        } else {
            words = ["Cant find File. Looking for file at: \(filePath.path)"]
        }
    }
}

