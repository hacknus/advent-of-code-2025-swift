//
//  Day01.swift
//  advent-of-code-2025-swift
//
//  Created by Linus Stöckli on 01.12.2025.
//

class Day01 : Day {
    override func part_1(filename: String = "input") -> String {
        let input = readInput(filename: filename)
        let lines = input.split(separator: "\n")
        
        var counter = 0;
        var position = 50;
        
        for line in lines {
            let distance = Int(line[line.index(after: line.startIndex)...])
            switch line[line.startIndex] {
            case "L": position += distance ?? 0
            case "R": position -= distance ?? 0
            default:
                print("Invalid direction: \(line)")
            }
            
            position = position % 100;
            while position < 0 {
                position += 100
            }
            
            if position == 0 {
                counter += 1
            }
            
        }
        
        return String(counter)
    }
    
    override func part_2(filename: String = "input") -> String {
        let input = readInput(filename: filename)
        let lines = input.split(separator: "\n")
        
        var counter = 0;
        var position = 50;
        
        for line in lines {
            let distance = Int(line[line.index(after: line.startIndex)...]) ?? 0
            switch line[line.startIndex] {
            case "L":
                for _ in 0..<distance {
                    position -= 1
                    if position < 0 {
                        position += 100
                    }
                    if position == 0 {
                        counter += 1
                    }
                }
                
            case "R" :
                for _ in 0..<distance {
                    position += 1
                    if position > 99 {
                        position -= 100
                    }
                    if position == 0 {
                        counter += 1
                    }
                }
                
            default:
                print("Invalid direction: \(line)")
            }
        }
        return String(counter)
    }
}
