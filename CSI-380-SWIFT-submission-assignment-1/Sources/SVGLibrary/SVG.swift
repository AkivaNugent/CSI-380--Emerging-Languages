//
//  SVG.swift
//  SierpinskiSwift
//
//  A class that can be used to generate
//  a basic SVG file.
//

//This file was edited by Akiva Nugent
// crefit: stackoverflow.com/questions/24097826/read-and-write-a-string-from-text-file
// this was used in write() try/catch
// *kind of* credit: I googled the output writing formatting, not seeing the header, but it just caused errors
// and i ended up copying formatting from the header :)

import Foundation

open class SVG {
    private var width:UInt
    private var height:UInt
    private var lines: [ (x1: Int, y1: Int, x2: Int, y2: Int, color: String) ]

    // Initialize the SVG file with commands that will create a
    // width x height canvas
    public init(width: UInt, height: UInt) {
        self.height = height
        self.width = width
        self.lines = []
    }
    
    public func drawLine (x1: Int, y1: Int, x2: Int, y2: Int, color: String) {
        self.lines.append((x1, y1, x2, y2, color))
    }
    
    // Write the SVG file to disk
    public func write(filePath: String) {
    var drawing = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
    drawing += "<svg version=\"1.1\" baseProfile=\"full\" width=\"\(width)\" height=\"\(height)\" xmlns=\"http://www.w3.org/2000/svg\">\n"

        for line in lines {
            drawing += "<line x1=\"\(line.x1)\" y1=\"\(line.y1)\" x2=\"\(line.x2)\" y2=\"\(line.y2)\" stroke=\"\(line.color)\" />\n"
        }

        drawing += "</svg>\n"

        do {
            try drawing.write(toFile: filePath, atomically: true, encoding: .utf8)
        } catch {
            print("Error writing SVG file: \(error)")
        }
        
    }

}
